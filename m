Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab3DIOPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:15:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33697 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760703Ab3DIOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:15:10 -0400
Message-ID: <51642262.10902@windriver.com>
Date: Tue, 9 Apr 2013 09:14:58 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <sedat.dilek@gmail.com>
CC: <kgdb-bugreport@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kdb: kgdb: CONFIG_DEBUG_RODATA setting?
References: <CA+icZUUkEgv+e1q3v1kW5WhJdT1egZKc5o96zF2omcT0YtVE3w@mail.gmail.com>
In-Reply-To: <CA+icZUUkEgv+e1q3v1kW5WhJdT1egZKc5o96zF2omcT0YtVE3w@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 08:06 AM, Sedat Dilek wrote:

>  config DEBUG_RODATA
>  	bool "Write protect kernel read-only data structures"
> -	default y
>  	depends on DEBUG_KERNEL
> +	default n if KGDB
> +	default y
>  	---help---
>  	  Mark the kernel read-only data as write-protected in the pagetables,
>  	  in order to catch accidental (and incorrect) writes to such const


This is wrong and should not be merged.

A) You should not change these defaults in this manner

B) You have pointed out that the documentation is currently
   incorrect. The CONFIG_DEBUG_RODATA constraints were removed some time
   ago, per commit 3751d3e85cf693e10e2c47c03c8caa65e171099b (x86,kgdb:
   Fix DEBUG_RODATA limitation using text_poke())

Jason.

