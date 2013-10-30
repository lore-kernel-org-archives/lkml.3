Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3J3S3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:29:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46567 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3J3S3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:29:23 -0400
Date: Wed, 30 Oct 2013 21:29:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kees Cook <keescook@chromium.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        yongjun_wei@trendmicro.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] befs: fix return value check in befs_iget()
Message-ID: <20131030182902.GK20521@mwanda>
References: <CAPgLHd_bHP-DMMbsFkc1RwmDK4dp+cZY8LRBFyDDuoEohJ-O_g@mail.gmail.com>
 <CAGXu5jKRTv_xW1kbPBR+GYNDvPTb5rirFXNZjGH17Rsssh8q4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKRTv_xW1kbPBR+GYNDvPTb5rirFXNZjGH17Rsssh8q4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:52:38AM -0700, Kees Cook wrote:
> On Mon, Oct 28, 2013 at 7:00 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > In case of error, the function iget_locked() returns NULL pointer
> > not ERR_PTR(). The IS_ERR() test in the return value check should
> > be replaced with NULL test.
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Good catch, thanks!
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> As an aside, Dan, how hard would this kind of mismatch be to detect
> with smatch?

It already does, but you need the cross function database set up.

regards,
dan carpenter

