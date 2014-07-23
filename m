Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaGWNwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:52:22 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63120 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaGWNwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:52:21 -0400
MIME-Version: 1.0
Date: Wed, 23 Jul 2014 16:52:21 +0300
Message-ID: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
Subject: Reading large amounts from /dev/urandom broken
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: tytso@mit.edu, hannes@stressinduktion.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear developers, please check bugzilla ticket
https://bugzilla.kernel.org/show_bug.cgi?id=80981 (not the initial
issue, but starting with comment#3.

Reading from /dev/urandom gives EOF after 33554431 bytes.  I believe
it is introduced by commit 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc,
with the chunk

nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));

which is described in commit message as "additional paranoia check to
prevent overly large count values to be passed into urandom_read()".

I don't know why people pull such large amounts of data from urandom,
but given today there are two bugreports regarding problems doing
that, i consider that this is practiced.

-- 
Andrey Utkin
