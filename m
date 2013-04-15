Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3DOA77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 20:59:59 -0400
Received: from nm20.bullet.mail.ird.yahoo.com ([77.238.189.77]:45615 "HELO
	nm20.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752484Ab3DOA76 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 20:59:58 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Apr 2013 20:59:57 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 668316.40413.bm@omp1014.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-RocketYMMF:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=G5Nm/topYfpqlrnEIwJweQL+zRsq4AZziIqqvvT7PbgRbuDv7qZeNr6nJm+u1LyFZx/fTKv7beSIONH3V3yiBsPXq8ooyFiEfvWHtzqp7tyt8ZBE4QNabO+hU+l4YEQHW02i1YQhw9gA61GxYg9pR1v07kHG48l+WlPJUH/B+Js=;
X-YMail-OSG: Gt1mjfUVM1mdzFiQLtm5JHw5mlmt2pkUpeNx2zC3h9SE5ii
 A1gApixaepfF.k.QWqhVV8AscMv5nKQ2GzE37anOESvzedxqGMTGmTo2z6V.
 O_fNr3BfDPWF7t1Vqybwk4.bazGaTebXr719V_oYiuEOHEesAETG2Fdnykbm
 TIn1yvD2Xj1Qh5iWIpW2U_13MExl.jk16B6RPN3QmuQFKQGALes7rJ9_DeaU
 .Cqe05AUyMzSDyl_fxVcaz25tj8xWm2IHiC8I2XRq4fUhG.LPLbCVA4eV.SQ
 Lsm4jS1PojT5olBjR6qkcuOH8p4urtspuRf3EZHVZZBFi3OHdLP33WyjdvAG
 .Tvk.Qy_TvsSyQtastEXrTaXZMMcSaMXwwRlQDvQM14z3zzk_0PizA9_hQM6
 D6Kd1VBGk1ZVHCCEn.mBlXRWZizdKfgwObwRhPDnIuNX0pQ7hmnhEyHrjg4T
 mUK8MJfXzTqQz4obJil7jhVIYRA5o2Lrpy7jUbgEs2fymNpGhbyjufVXWXGA
 A66UO
X-Rocket-MIMEInfo: 002.001,LS0tIE9uIE1vbiwgOC80LzEzLCBKb2UgUGVyY2hlcyA8am9lQHBlcmNoZXMuY29tPiB3cm90ZToKCj4gVXNlIGEgbW9yZSBjdXJyZW50IGxvZ2dpbmcgc3R5bGUuCj4gCj4gUmVuYW1lIG1hY3JvIGFuZCB1c2VzLgo.IEFkZCBkbyB7fSB3aGlsZSAoMCkgdG8gbWFjcm8uCj4gQWRkIERCR18gdG8gbWFjcm8uCj4gQWRkIGFuZCB1c2UgaGZzX2RiZ19jb250IHZhcmlhbnQgd2hlcmUgYXBwcm9wcmlhdGUuCj4gCj4gU2lnbmVkLW9mZi1ieTogSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4KCjxhIGxvdCBvZiABMAEBAQE-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/15.1.7 YahooMailWebService/0.8.140.532
Message-ID: <1365987181.4850.YahooMailClassic@web172306.mail.ir2.yahoo.com>
Date: Mon, 15 Apr 2013 01:53:01 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
To: Vyacheslav Dubeyko <slava@dubeyko.com>, Joe Perches <joe@perches.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <60b028ebc7235d8ba4ff1a2e936f879e0d806a9b.1365438494.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 8/4/13, Joe Perches <joe@perches.com> wrote:

> Use a more current logging style.
> 
> Rename macro and uses.
> Add do {} while (0) to macro.
> Add DBG_ to macro.
> Add and use hfs_dbg_cont variant where appropriate.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

<a lot of dprint to hfs_dbg changes snipped>

> +++ b/fs/hfs/hfs_fs.h
> @@ -34,8 +34,18 @@
>  //#define DBG_MASK   
> (DBG_CAT_MOD|DBG_BNODE_REFS|DBG_INODE|DBG_EXTENT)
>  #define DBG_MASK    (0)
>  
> -#define dprint(flg, fmt, args...) \
> -    if (flg & DBG_MASK) printk(fmt , ##
> args)
> +#define hfs_dbg(flg, fmt, ...)   
>             \
> +do {       
>            
>         \
> +    if (DBG_##flg &
> DBG_MASK)       
>     \
> +        printk(KERN_DEBUG
> fmt, ##__VA_ARGS__);    \
> +} while (0)
> +
> +#define hfs_dbg_cont(flg, fmt, ...)   
>         \
> +do {       
>            
>         \
> +    if (DBG_##flg &
> DBG_MASK)       
>     \
> +        printk(KERN_CONT fmt,
> ##__VA_ARGS__);    \
> +} while (0)
> +
>  
>  /*
>   * struct hfs_inode_info

<a lot of dprint to hfs_dbg change snipped>

This set of change seems to be somewhat zealous - it doesn't offer any benefits other than possibly satisfying somebody's idea of code-purity.

FWIW, I have been sitting on a patch which changes this part of the code to dynamic debugging, and it is much simplier. Just:

=============================
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index e298b83..55d211d 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -45,8 +25,7 @@
 #define HFSPLUS_JOURNAL_SWAP           1
 
 #define dprint(flg, fmt, args...) \
-       if (flg & DBG_MASK) \
-               printk(fmt , ## args)
+               pr_debug(fmt , ## args)
 
 /* Runtime config options */
 #define HFSPLUS_DEF_CR_TYPE    0x3F3F3F3F  /* '????' */
=========================

(and you can then remove all the DBG_* defines before that, since they then don't have any effect any more).

The benefit of this alternative is that it does not break any out-of-tree patches, while make it easier to debug say patches... and I am still sitting on a rather substantial set of the journal change, plus all the other issues that come out of it, like the folder count patch for case-sensitive file systems.

I think one needs to think very carefully about make bulk changes like this, which serves no real purpose other than satisfying somebody's idea of code purity.

The problem with such bulk "stylistic" changes, is that it forces people who are working on real functionalities and bug fixes to rebase their work, and spend time on doing so, and also at the risk introducing new bugs while rebasing. I know I am writing on a somewhat selfish purpose: if I need to rebase my work due to other's bug fixes or enhancement, etc, then fair enough, but I'd prefer not to rebase for the purpose of other's preference of, and attempts at re-arranging the style of the debug statements, when the debugging output means little to them.





