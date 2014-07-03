Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbaGCSPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:15:37 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:40278 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaGCSPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:15:35 -0400
Message-ID: <53B59DC2.20809@twiddle.net>
Date: Thu, 03 Jul 2014 11:15:30 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: ink@jurassic.park.msu.ru, Matt Turner <mattst88@gmail.com>,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FIX ME message in osf_sys.c
References: <CAPDOMVj3sJSfgA7hBv9Tx0oz5ZX73robsTZygVJfU_QZ9A65dg@mail.gmail.com>
In-Reply-To: <CAPDOMVj3sJSfgA7hBv9Tx0oz5ZX73robsTZygVJfU_QZ9A65dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 10:21 AM, Nick Krause wrote:
> There seems to be a Fix Me message on line 892 due to info.si_addr = NULL.
> I am wondering what value I should declare this variable to instead of Null.
> Cheers Nick
> 

The closest thing to compatibility with SIGFPE raised through normal arithmetic
would be the address of the instruction after the callsys that lead to this
system call.  Except that's not available without complicating the call to
osf_setsysinfo, and it doesn't seem worth it.


r~
