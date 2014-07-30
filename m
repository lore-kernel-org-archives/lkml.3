Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaG3Ta4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:30:56 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:55928 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbaG3Tay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:30:54 -0400
Message-ID: <53D947E4.7020305@twiddle.net>
Date: Wed, 30 Jul 2014 09:30:44 -1000
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Bug: retry of clone() on Alpha can result in zeroed process thread
 pointer
References: <20140723085244.GB4799@omega>
In-Reply-To: <20140723085244.GB4799@omega>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I think I've actually found it this time.  It's here:

> 281		childregs->r20 = 1;	/* OSF/1 has some strange fork() semantics.  */
> 282		regs->r20 = 0;

We need to delay this r20 silliness until after restarts or something.  Or just
kill it -- it's not like glibc uses this return value.


r~
