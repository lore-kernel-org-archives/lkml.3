Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3CKS1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab3CKS1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:27:11 -0400
Date: Mon, 11 Mar 2013 14:26:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311182655.GB12107@redhat.com>
References: <513D52BA.3070206@redhat.com>
 <1362977817-23297-1-git-send-email-yinghai@kernel.org>
 <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:58:39AM -0700, Yinghai Lu wrote:
> On Mon, Mar 11, 2013 at 8:02 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > IOW, wouldn't it be better that crashkernel=X first tries to find
> > requested amount of memory in lowest memory area available/possible.
> 
> Yest, that is much better, and user even could stay with old kexec-tools
> for system that does not tons of memory.
> And I don't need to mess up with auto setting crashkernel_low or export
> swiotlb_size() etc.
> 
> Please check if you are ok with attached one.
> 
Hi Yinghai,

In mutt your patches are showing as attachment instead of inline. Mutt
thinks attachment is of type "application/octet-stream". Not sure if
this is configuration issue on my part or something is going on your
end.

I have few more concerns.

- Are we able to reserve 512MB memory now below 896MB. I remember so
  far it was broken.

- If reserving memory below 896MB fails, we immediately switch to
  reserving anywhere till MAXMEM. Would it make sense to first try
  to reserve it below 4G (so that we don't have to worry much about
  swiotlb or iommu being on).

Thanks
Vivek

