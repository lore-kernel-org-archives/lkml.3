Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbaJaPWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:22:44 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:62141 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbaJaPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:22:43 -0400
MIME-Version: 1.0
Date: Fri, 31 Oct 2014 15:22:39 +0000
Message-ID: <CAN628AF+h9CnfFqMyRHKx=8E9egvcB0rd+_oCY4Q-4gq4NMn=Q@mail.gmail.com>
Subject: arch/microblaze/kernel/head.S: redundant code?
From: Adrian McMenamin <lkmladrian@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: monstr@monstr.eu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at this code at line 78 (in 3.17 kernel) it has:

    mfs r1, rmsr
    msrclr r8, 0
    cmpu r8, r8, r1

But as far as I can see the result of that comparison is never used -
the comments state it is to test if the msrclr  instruction is
enabled.

Haven't posted a patch because I am using the code to understand how
to write my own boot code for a very specific Microblaze application -
but perhaps someone with real expertise could look and/or tell me I'm
wrong?

Cheers

Adrian

(apologies to Michal Simek for getting this twice)
