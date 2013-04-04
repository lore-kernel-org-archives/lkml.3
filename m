Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311Ab3DDNvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760635Ab3DDNvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:51:21 -0400
Date: Thu, 4 Apr 2013 09:51:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130404135108.GB16459@redhat.com>
References: <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
 <20130402201148.GJ29506@redhat.com>
 <CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
 <20130403131842.GA5939@redhat.com>
 <CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
 <CAE9FiQXg2+DCd0BGRyKo4KWsMXdPZz74OjpQrUP=ciok2AZhuA@mail.gmail.com>
 <20130403174734.GG5939@redhat.com>
 <CAE9FiQU96BjThKbOGBhc6RHBey2+bvM6J6ZYaLb=xGuwahTuLQ@mail.gmail.com>
 <20130403210019.GH5939@redhat.com>
 <CAE9FiQXnDu9R9YkTS9=726ztK049O=xfSgPhwTWxT+0xz3gnAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXnDu9R9YkTS9=726ztK049O=xfSgPhwTWxT+0xz3gnAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 05:56:00PM -0700, Yinghai Lu wrote:

[..]
> 
> One big rang under 4G is working well till second kernel need more than 512M
> on bigger system with more memory.

Currently one range is allocated below 896MB (and not 4G). So if we extend
crashkernel=X to first try below 896MB and then reserve below 4G, we are
just fine. And in fact we should be able to extend to even look beyond
4G if nothing suitable is available below 4G.

Thanks
Vivek
