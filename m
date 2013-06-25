Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3FYSpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:45:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45546 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab3FYSpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:45:12 -0400
Message-ID: <51C9E523.7000803@zytor.com>
Date: Tue, 25 Jun 2013 11:44:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Mike Travis <travis@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <51C4C5F3.3050800@sgi.com> <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com> <51C9D4ED.5070805@sgi.com> <51C9DEC1.6030602@zytor.com> <CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com>
In-Reply-To: <CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 11:40 AM, Yinghai Lu wrote:
> On Tue, Jun 25, 2013 at 11:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/25/2013 10:35 AM, Mike Travis wrote:
> 
>> However, please consider Ingo's counterproposal of doing this via the
>> buddy allocator, i.e. hugepages being broken on demand.  That is a
>> *very* powerful model, although would require more infrastructure.
> 
> Can you or Ingo elaborate more about the buddy allocator proposal?
> 

Start by initializing 1G hyperpages only, but mark them so that the
allocator knows that if it needs to break them apart it has to
initialize the page structures for the 2M subpages.

Same thing with 2M -> 4K.

	-hpa


