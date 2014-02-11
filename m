Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBKW0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:26:51 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60299 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaBKW0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:26:48 -0500
Date: Tue, 11 Feb 2014 14:26:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string
 handling
In-Reply-To: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com>
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Paul Gortmaker wrote:

> Fixes:
> 
> arch/x86/boot/compressed/../string.c:60:14: warning: symbol 'atou' was not declared. Should it be static?
> arch/x86/boot/string.c:133:6: warning: symbol 'strstr' was not declared. Should it be static?
> 
> The atou one could be considered a false positive; it seems somehow
> caused by including ./string.c from within /compressed/string.c file.
> However git grep shows only the atou prototype and declaration, so
> it is completely unused and we can hence delete it.
> 

Declaring a prototype in a header file would be pointless if there is no 
current breakage; I don't see why you can't remove strstr() in 
arch/x86/boot/string.c entirely.  What breaks?
