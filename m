Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaJSJqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:46:32 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39663 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaJSJqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:46:30 -0400
MIME-Version: 1.0
Date: Sun, 19 Oct 2014 11:46:29 +0200
Message-ID: <CABbAP1QWTorBt+f-nCmw1Q_DPe1CLecXYGUJFAcQkuw0Rk6d2g@mail.gmail.com>
Subject: Sparse warning: "initializer entry defined twice" - sparse can't
 handle bool?
From: Mariusz Gorski <marius.gorski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse throws the following warning, which I can't really understand:

$ make drivers/staging/vt6655/ C=2
[...]
  CHECK   drivers/staging/vt6655/datarate.c
drivers/staging/vt6655/datarate.c:302:40: warning: Initializer entry
defined twice
drivers/staging/vt6655/datarate.c:302:46:   also defined here

The code looks fine to me:
bool bAutoRate[MAX_RATE]    = {true, true, true, true, false, false,
true, true, true, true, true, true};

I've googled it and found only this LKML discussion:
https://lkml.org/lkml/2010/5/7/31

I've tested the suggested code sample and here are the results:
$ cat foo.c
typedef _Bool bool;
enum {
     false = 0,
     true = 1
};
static const bool foo[10] = {
       true,
       true,
       false,
       false,
};

$ sparse foo.c
foo.c:7:8: warning: Initializer entry defined twice
foo.c:8:8:   also defined here

It this a sparse problem?

Thanks,
Mariusz
