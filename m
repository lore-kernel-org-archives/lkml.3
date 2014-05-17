Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbaEQQxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:53:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54301 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964774AbaEQQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:53:47 -0400
Date: Sat, 17 May 2014 17:53:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Manuel =?iso-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Cleanup string initializations (char[] instead of
 char *)
Message-ID: <20140517165345.GG18016@ZenIV.linux.org.uk>
References: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 05:00:18PM +0200, Manuel Schölling wrote:
> Initializations like 'char *foo = "bar"' will create two variables: a static
> string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> will declare a single variable and will end up in shorter
> assembly (according to Jeff Garzik on the KernelJanitor's TODO list).

The hell it will.  Compare assembler generated e.g. for 32bit x86 before
and after.

>  {
>  	char *dp;
>  	char *status = "disabled";
> -	const char * flags = "flags: ";
> +	const char flags[] = "flags: ";

The first variant puts address of constant array into local variable
(on stack or in a register).  The second one fills local _array_ - the
string itself goes on stack.
