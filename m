Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3ANKqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:46:10 -0500
Received: from nm4.bullet.mail.ird.yahoo.com ([77.238.189.61]:46820 "EHLO
	nm4.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab3ANKqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:46:08 -0500
X-Yahoo-Newman-Id: 160357.4792.bm@smtp118.mail.ird.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sqS9sDsVM1nVDhGGleElJLF7Bw1d.njIDegQunhMo.f7XCE
 MnQFjmPcG.wGDLh9sL4WgCs80EDFxo.acDw3SByFcxTWeSwWKQKBGuayuiCl
 z0EK4CGFmjrSocJYBC9jgoV_0NKh6Cs.AgpxtIIIDj2IFy9FkoEIwzVSdOPW
 ziyGpjTS2i.fMOdZWozb6kKOcmdMrq6BahjIHdEk3dDrCNJhhpqxgbwRqnAt
 Qm7L0ns5IqAOE..s052p8Uwj1PCsFIGqYIiuJW580D75CLx4wKmnrcJqv86i
 tDFrUslCP7aSNkO.6xnkSd3nW81lj1O.0y8wGu_z1ec2FysyNa_CThJu6kI4
 ocIg6GxJL7Pykq3sSux2Fq85IjRq3wPTSpsssFLy5ZZ8Ti2OWcN7kGhX9TmU
 X4Lb4tk4mjRB0H00rEQ--
X-Yahoo-SMTP: mOFZFAuswBAG4_8a4ZBj.Wmvw2Qxc4R7nmE-
From: Schrober <franzschrober@yahoo.de>
To: linux-kernel@vger.kernel.org
Subject: container-of Implementation
Date: Mon, 14 Jan 2013 11:46:05 +0100
Message-ID: <1635127.Ytukyo95FQ@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wondered why the container_of implementation is so complicated.

#define container_of(ptr, type, member) ({			\
	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
	(type *)( (char *)__mptr - offsetof(type,member) );})

isn't the __mptr not unnecessary? Why not following version?

#define container_of(ptr, type, member) \
    ((type *)((char *)(ptr) - offsetof(type, member)))
-- 
Franz Schrober
