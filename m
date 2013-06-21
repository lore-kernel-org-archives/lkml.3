Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423673Ab3FUSoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:44:24 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58242 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FUSoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:44:23 -0400
MIME-Version: 1.0
In-Reply-To: <51C48745.9030304@zytor.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<20130621165142.GA32125@kroah.com>
	<51C48745.9030304@zytor.com>
Date: Fri, 21 Jun 2013 11:44:22 -0700
X-Google-Sender-Auth: I1y_2-k25Y5ZFBq8QqC8NcrC59M
Message-ID: <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Nathan Zimmer <nzimmer@sgi.com>,
        Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/21/2013 09:51 AM, Greg KH wrote:
>
> I suspect the cutoff for this should be a lot lower than 8 TB even, more
> like 128 GB or so.  The only concern is to not set the cutoff so low
> that we can end up running out of memory or with suboptimal NUMA
> placement just because of this.

I would suggest another way:
only boot the system with boot node (include cpu, ram and pci root buses).
then after boot, could add other nodes.

or something like pxm_mask or node_mask to select boot nodes.

Thanks

Yinghai
