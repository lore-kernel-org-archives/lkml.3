Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3CKTif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3CKTid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:38:33 -0400
Date: Mon, 11 Mar 2013 15:38:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311193824.GA14738@redhat.com>
References: <1362977817-23297-1-git-send-email-yinghai@kernel.org>
 <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <20130311191031.GD12107@redhat.com>
 <CAE9FiQUxmipKJfUsZdN+J6wGR66VKfLQ8+z41yd3TCJxXTyDRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUxmipKJfUsZdN+J6wGR66VKfLQ8+z41yd3TCJxXTyDRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:34:00PM -0700, Yinghai Lu wrote:
> On Mon, Mar 11, 2013 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Not breaking existing cases makes sense to me.
> 
> that is -v2 version:
> try 896M, then try 4G, than MAXMEM.
> 
> > May be we should use
> > a new parameter crashkernel_high to force memory reservation above
> > 4G and crashkernel=X continues to reserve memory at lower addresses
> > and remains backward compatible.
> 
> No need to use crashkernel_high, we can just cashkernel=X@Y instead.

crashkernel=X@Y is little different. It assumes user knows the memory
map and location "Y" is fixed. There might not be any memory at "Y".

So it is not same.

Thanks
Vivek
