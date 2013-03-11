Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3CKTKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:10:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3CKTKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:10:36 -0400
Date: Mon, 11 Mar 2013 15:10:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311191031.GD12107@redhat.com>
References: <513D52BA.3070206@redhat.com>
 <1362977817-23297-1-git-send-email-yinghai@kernel.org>
 <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E28B8.3000502@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:55:52AM -0700, H. Peter Anvin wrote:
> On 03/11/2013 11:50 AM, Yinghai Lu wrote:
> >>
> >> What is the purpose of reserving that kind of memory below 896 MB?  If
> >> you have a 32-bit system, it will likely be useless since you are
> >> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
> >> a magic value in any way...?
> > 
> > We did not touch 32 bit system.
> > 
> > Do you mean that we should
> > For 64bit, we should try under 4G, and then try MAXMEM
> > instead of try under 896M, then 4G, and MAXMEM?
> > 
> > Try 896M at first, we will let user to avoid updating their kexec-tools.
> > 
> 
> Are you saying 896M is somehow hardcoded into kexec-tools?
> 
> I actually disagree with trying low memory at all.  Push kdump as high
> into the memory range as we can go, if there is a performance penalty it
> is much better to take it in the kdump kernel.

Reserving above 2G by default will break old kexec-tools. Purgatory can't
be loaded above 2G.

Loading above 4G will require swiotlb buffers to be reserved in low
memory area. It will break all the existing setups where iommu is
not enabled.

Not breaking existing cases makes sense to me. May be we should use
a new parameter crashkernel_high to force memory reservation above
4G and crashkernel=X continues to reserve memory at lower addresses
and remains backward compatible.

Thanks
Vivek
