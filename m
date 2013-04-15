Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3DOB4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:56:18 -0400
Received: from nm7.bullet.mail.ird.yahoo.com ([77.238.189.21]:38428 "HELO
	nm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752734Ab3DOB4R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:56:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 901203.12370.bm@omp1051.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-RocketYMMF:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RmCym/tptc5Iyj5RkqhvCilIzumBRmnI/GLhfgVV3AFl0HQbu1p5N9AQlgoKXRc4O1d7mMmUzlpNDDw9LiFQ7jGWYP/N8Y+5vVgC8YNP44+79Wcny3l4y9JoF9JH9n7tS9XTcfzklV9LEMs1BdGhChpVRk0LqDY3nqQaSdeM9mc=;
X-YMail-OSG: R_MExMYVM1mx8BBEUfJSsmYXH0uV_lp0w9Z7YMJ8lE0vVU1
 WD7sJKxqERF3hovVU58GiW43miFy_t275d.yoknU8DX_kk.y8H0Jc4A.A1hB
 gLbtIRY9cA4bunr.T9p4ANMSCknDrVCVlnOY_ZFbsI4rPiGfVl143SHhb6AD
 YzbTo_VHVbs73kViAk2opXtTEl3QU3oLpMhsolMW8l5Yrkekyvp5MNIz_I5n
 2JmZ92a_g.saGnxtgAz2NBLPjqb.2zmdbsPWEUxTRtZwc6UHUe_nIdUXVM4E
 2cr1vtqTLmWfg4bxJ4klAzlK6ndd1yow.SgwssDYepLoO42AgMUWJoJwADQY
 SNw16DYMwNweIuHpCDPsvEuffxfCYX0.untXTafzYVfILlHRpLKgigAEU_k3
 tJmGboEHhDCx0VGwOOgehyY.WJhtnf_HEgnCdQSesgG5nhJNkGUVNlxok8wV
 7wbDkcqykHjA1zAhY2Bt5KL4g3A5Y223g5JEByOamcdAqRE8OYYGhwntP7dO
 JKZ9V
X-Rocket-MIMEInfo: 002.001,LS0tIE9uIE1vbiwgMTUvNC8xMywgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4gd3JvdGU6Cgo.IE9uIE1vbiwgMjAxMy0wNC0xNSBhdCAwMTo1MyArMDEwMCwKPiBIaW4tVGFrIExldW5nIHdyb3RlOgo.ID4gLS0tIE9uIE1vbiwgOC80LzEzLCBKb2UgUGVyY2hlcyA8am9lQHBlcmNoZXMuY29tPgo.IHdyb3RlOgo.ID4gPiBVc2UgYSBtb3JlIGN1cnJlbnQgbG9nZ2luZyBzdHlsZS4KPiBbXQo.ID4gSSBoYXZlIGJlZW4gc2l0dGluZyBvbiBhIHBhdGNoIHdoaWNoIGNoYW5nZXMgdGhpcyBwYXJ0Cj4gb2YBMAEBAQE-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/15.1.7 YahooMailWebService/0.8.140.532
Message-ID: <1365990973.28177.YahooMailClassic@web172303.mail.ir2.yahoo.com>
Date: Mon, 15 Apr 2013 02:56:13 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
To: Joe Perches <joe@perches.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1365990674.1878.21.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 15/4/13, Joe Perches <joe@perches.com> wrote:

> On Mon, 2013-04-15 at 01:53 +0100,
> Hin-Tak Leung wrote:
> > --- On Mon, 8/4/13, Joe Perches <joe@perches.com>
> wrote:
> > > Use a more current logging style.
> []
> > I have been sitting on a patch which changes this part
> of the code to dynamic debugging, and it is much simplier.
> Just:
> > #define dprint(flg, fmt, args...) \
> > -       if (flg &
> DBG_MASK) \
> > -           
>    printk(fmt , ## args)
> > +           
>    pr_debug(fmt , ## args)
> 
> This change wouldn't work well as it would make a mess
> of output that uses no prefix (ie: emits at KERN_DEFAULT)
> with output that uses KERN_DEBUG
> 
> That's the reason for _dbg and _dbg_cont.

Hmm, I don't get it. Is there any *existing* use of dprint in the hfplus code which is affected by your comment? Or is this another general stylistic comment? i.e. "this does not work in general"?


