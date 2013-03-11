Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3CKTRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3CKTRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:17:47 -0400
Date: Mon, 11 Mar 2013 15:17:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311191734.GE12107@redhat.com>
References: <513D52BA.3070206@redhat.com>
 <1362977817-23297-1-git-send-email-yinghai@kernel.org>
 <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <20130311190242.GC12107@redhat.com>
 <513E2AC6.1000707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E2AC6.1000707@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:04:38PM -0700, H. Peter Anvin wrote:
> On 03/11/2013 12:02 PM, Vivek Goyal wrote:
> >>
> >> What is the purpose of reserving that kind of memory below 896 MB?  If
> >> you have a 32-bit system, it will likely be useless since you are
> >> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
> >> a magic value in any way...?
> > 
> > Actually I am not sure where did 896MB magic value had come from for
> > x86_64 so far. I assumed that it was some kexec-tools limitation so
> > first trying 896MB will preserve working with old kexec-tools. If it
> > was some kernel limitation, then I agree it should not be required anymore.
> > 
> > I do remember that old pugatory had 2G limit. So may be we can first
> > try reserve with-in first 2G, then with-in first 4G and then above
> > 4G. (Assuming 896M was not kexec-tools limitation and had something
> > to do with kernel/initramfs).
> > 
> 
> It is obvious where it *originated* from... it is the *default* (but not
> necessarily the actual!) HIGHMEM crossover point on x86-32.
> 

On x86-32, max addr limit is 512M. 896M limit is on x86_64. So it probably
came from somewhere else. 

Also always reserving at high memory cuts down on what kind of bzImage
can be booted from that address. For example, x86_32bit kernels. Hence
reserving at low addresses enables booting more type of images without
rebooting.

Thanks
Vivek
