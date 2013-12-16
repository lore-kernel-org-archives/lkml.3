Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3LPEWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:22:51 -0500
Received: from science.horizon.com ([71.41.210.146]:29709 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752240Ab3LPEWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:22:50 -0500
Date: 15 Dec 2013 23:22:47 -0500
Message-ID: <20131216042247.9826.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20131215221948.GA6773@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, Dec 15, 2013 at 03:34:59AM -0500, George Spelvin wrote:
>> You're describing standard key-recovery attacks.  For /dev/random,
>> just knowing the *ciphertext* constitutes a successful attack.

> Um, no.  The *ciphertext* is the output.  The attacker can get all of
> the ciphertext he or she wants by reading /dev/random (although we'd
> probably do some folding as we currently do so the attacker won't even
> get all of the ciphertext).  What the attacker has to be able to do is
> given some of the ciphertext bits, be able to predict future
> ciphertext bits given some construction which uses AES as the basis.

The attack I was thinking of was figuring out (without breaking root and
using ptrace) what some *other* process on the same machine is reading
from /dev/random.

In other words, reading someone else's output.
