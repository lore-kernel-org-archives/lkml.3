Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaJWQEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:04:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbaJWQEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:04:09 -0400
Date: Thu, 23 Oct 2014 18:04:05 +0200
From: Jan Kara <jack@suse.cz>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-ima-devel <linux-ima-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ima: check xattr value length in ima_inode_setxattr()
Message-ID: <20141023160405.GC21034@quack.suse.cz>
References: <cover.1414071910.git.d.kasatkin@samsung.com>
 <5b1f234e8515c10c96a16868ff4341f29460f38f.1414071910.git.d.kasatkin@samsung.com>
 <20141023154007.GA21034@quack.suse.cz>
 <CACE9dm9zB0h6CU+oHUowm3=Oy7Kpx9q4tp78pb-5myRCpTXLZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACE9dm9zB0h6CU+oHUowm3=Oy7Kpx9q4tp78pb-5myRCpTXLZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-10-14 18:59:07, Dmitry Kasatkin wrote:
> On 23 October 2014 18:40, Jan Kara <jack@suse.cz> wrote:
> > On Thu 23-10-14 16:47:17, Dmitry Kasatkin wrote:
> >> ima_inode_setxattr() can be called with no value. Function does not
> >> check the length so that following command can be used to produce
> >> kernel oops: setfattr -n security.ima FOO. This patch fixes it.
> >>
> > ..
> >>
> >> Reported-by: Jan Kara <jack@suse.cz>
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >> ---
> >>  security/integrity/ima/ima_appraise.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> >> index 5b845af..f07aacd 100644
> >> --- a/security/integrity/ima/ima_appraise.c
> >> +++ b/security/integrity/ima/ima_appraise.c
> >> @@ -378,6 +378,8 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
> >>       result = ima_protect_xattr(dentry, xattr_name, xattr_value,
> >>                                  xattr_value_len);
> >>       if (result == 1) {
> >> +             if (!xattr_value_len)
> >> +                     return -EINVAL;
> >   Wouldn't it be safer to return EINVAL whenever xattr_value_len !=
> > sizeof(evm_ima_xattr_data)?
> 
> In this function we only use first byte to identify attribute type.
> sizeof(evm_ima_xattr_data) is SHA1_DIGEST_SIZE + 1.
> But IMA may use any other algorithm where digest size is different.
  I see. Thanks for explanation.

								Honza

> >>               ima_reset_appraise_flags(dentry->d_inode,
> >>                        (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
> >>               result = 0;
> >> --
> >> 1.9.1
> >>
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> 
> 
> 
> -- 
> Thanks,
> Dmitry
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
