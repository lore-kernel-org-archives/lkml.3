Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab3IQNAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:00:50 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38542 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3IQNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:00:49 -0400
MIME-Version: 1.0
Date: Tue, 17 Sep 2013 14:00:48 +0100
Message-ID: <CACu8kRTN7XoTxvcFHQ=7N-rUGoUePS43EwRKax25mqBjzEXNVg@mail.gmail.com>
Subject: Lightweight type analysis for memory safety through verification of
 API uses
From: Marcelo Sousa <marceloabsousa@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: msousa@cs.ox.ac.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(* Apologies if this is a duplicate: I screw up the plain text before *)

Hello all,

I've designed and implemented a tool similar to sparse and CQUAL that
does type inference of user specified type qualifiers, e.g. iomem. It
receives an API specification with the type qualifiers and also a
partial order, e.g. IOAddr is not compatible with KernelAddr and
ioremap returns a pointer to IOAddr while __kmalloc returns a pointer
to a KernelAddr.

The tool is part of a verification framework for LLVM that I'm
developing called llvmvf. I'm using the llvmlinux project to compile
with clang and I perform intra/interprocedural analysis on every IR
module. I can easily extend to inter-module analysis for a whole
driver analysis.

The performance results are quite fast when compared to similar tools:
less than 5 min to analyse the entire source code (~9k modules;
millions of constraints).

Initially, I focused on separation of IO vs regular memory and I
implemented a partial transformation that converts inline assembly to
LLVM IR functions because I'm also interested in catching misuses of
atomic instructions with IO memory pointers.

I'm looking for bugs related to misuses of IO pointers to validate my
approach and have a good direction on how to increase the precision.
More importantly, I'm looking for other use cases that are likely to
produce a small number of false positives and could be useful to the
linux kernel community. I would like your general feedback and
suggestions of analysis. In particular, I'm thinking on using this
approach to verify the DMA API, and I'm looking for known bugs that
could be used for validation.

Kind regards,
Marcelo
