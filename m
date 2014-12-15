Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaLOQTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:19:23 -0500
Received: from mx02.posteo.de ([89.146.194.165]:32855 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbaLOQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:19:12 -0500
From: Martin Kepplinger <martink@posteo.de>
To: peterz@infradead.org
Cc: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: add sign-extend functions for 8 and 16 bit values
Date: Mon, 15 Dec 2014 17:18:31 +0100
Message-Id: <1418660317-21750-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In short: If you want the first 2 changes, please merge them and notify 
me.

This adds sign_extend8() and sign_extend16() for the quite many cases
where this is needed, like sign_extend32().

Sign-extending is done in a few different ways throughout the kernel
and most of them look not very beautiful, adding non-obvious constant
values. This would simplify things.

I append four example changes for existing drivers. I'm aware that you
are not resposible for these, but I'd post them to the relevant
maintainers only if you want to apply to bitops.h.

While I would definitely move on moving drivers over to this, when I find
them, I can't guarantee I'd change every sign-extension out there myself.
