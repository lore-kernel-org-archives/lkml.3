Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3EQToO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:44:14 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:54960 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3EQToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:44:13 -0400
Message-ID: <5196887A.2010906@ahsoftware.de>
Date: Fri, 17 May 2013 21:43:54 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tty: make sure a BUG is hit if tty_port will be destroyed
 before tty
References: <5195B561.3090503@ahsoftware.de> <1368774728-4817-1-git-send-email-holler@ahsoftware.de> <20130517153136.GC19541@kroah.com> <51965DC0.7030901@ahsoftware.de> <5196718D.30904@hurleysoftware.com> <5196835B.4060100@ahsoftware.de>
In-Reply-To: <5196835B.4060100@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.05.2013 21:22, schrieb Alexander Holler:

> The case that the machine didn't die, but just the process, only happens
> when my proposed patch is applied, which prevents the memory corruption.

In short, the proposed BUG_ON() prevents the memory corruption because
it is hit before something bad can happen. The result is that just the
process in question will be killed (and a tty is not released), but only
that BUG_ON() prevents that something _really_ bad happens.

I hope I could describe it now clearly. ;)

Regards,

Alexander

