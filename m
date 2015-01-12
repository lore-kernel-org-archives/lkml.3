Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbbALPl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:41:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbbALPlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:41:24 -0500
Message-ID: <54B3EB1C.3020208@redhat.com>
Date: Mon, 12 Jan 2015 16:41:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, gleb@kernel.org
CC: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Questions about to dos in emulate.c
References: <54B0A714.5070903@gmail.com>
In-Reply-To: <54B0A714.5070903@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/01/2015 05:14, nick wrote:
> Greetings Again Everyone,
> I have a few questions about fix mes in emulate.c. They are listed
> in numerical order below.
> 1. For  __emulate_int_real somebody stated we need limit checks. What
> checks are needed for my information.

These are written in the manual as

  IF stack not large enough for a 6-byte return information
     THEN #SS; FI;

> 2. Secondly,about the function, emulate_iret_real are what do you mean 
> by stack limit checks and if possible what parts of the stacks for either
> guest(s) or hosts we need to check.

Same here:

  IF top 6 bytes of stack are not within stack limits
     THEN #SS; FI;

Paolo

> In addition if you need help with other work, please don't feel free to
> contact me.
> Thanks and Regards,
> Nick 
> 
