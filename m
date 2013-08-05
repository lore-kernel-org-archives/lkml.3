Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3HEOrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:47:47 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:26011 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756Ab3HEOrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:47:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,819,1367964000"; 
   d="scan'208";a="28546969"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] adjust code alignment
Date: Mon,  5 Aug 2013 16:47:35 +0200
Message-Id: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches result from the following semantic patch
(http://coccinelle.lip6.fr/), which checks for successive statements that
are not aligned.

@bad@
statement S;
expression e;
position p1,p;
@@

S@p1
e@p;

@script:ocaml@
p1 << bad.p1;
p << bad.p;
@@

if not ((List.hd p1).line = (List.hd p).line)
then include_match false

@r@
expression e1,e2;
position p1 != bad.p,p2;
@@

e1@p1;
e2@p2;

@script:ocaml@
p1 << r.p1;
p2 << r.p2;
@@

if not ((List.hd p1).col = (List.hd p2).col) &&
   not ((List.hd p1).line = (List.hd p2).line)
then begin print_main "" p1; print_secs "" p2 end

