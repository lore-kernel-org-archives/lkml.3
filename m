Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750784AbbABKEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:04:23 -0500
Received: from www.osadl.org ([62.245.132.105]:41263 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbbABKEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:04:22 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 RFC] Coccinelle: completion API checking
Date: Fri,  2 Jan 2015 04:59:09 -0500
Message-Id: <1420192752-4889-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This little set of semantic patches is for partially checking the
completion API. It seems to be working correctly and has not yet
produced any false-positive.

The cases being detected are:

1/3 - duplicate init_completions.
2/3 - incorrect static initialization of completion on stack.
3/3 - re-initialization of completion with init_completion() rather
      than reinit_completion().

semantic patch                  findings   files  confirmed
duplicate_init_completion.cocci    2         2        2
false_declare_completion.cocci     6         5        3 
false_init_compltion.cocci         9         6        5 

Note: false_declare_completion.cocci runs extremely slow on my system
      roughly a factor 10 slower than the other two - not clear why.

All findings have been submitted based on these scripts. Some have 
not yet been confirmed.

Note sure if it makes sense putting this type of API misuse cleanup
into mainline given the relatively small number of findings.

patch is against linux-next 3.19.0-rc1 (-next-20141226)

