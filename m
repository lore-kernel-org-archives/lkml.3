Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaIBTxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:53:21 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:33007 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaIBTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:53:19 -0400
Message-ID: <5406202A.30401@amacapital.net>
Date: Tue, 02 Sep 2014 12:53:14 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: How is pivot_root intended to be used?
References: <fc0cb509956.5404e2cc@langara.bc.ca>
In-Reply-To: <fc0cb509956.5404e2cc@langara.bc.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 02:19 PM, Steven Stewart-Gallus wrote:
> Hello,
>
> I am not confused about how I can currently use pivot_root for
> containers on my kernel (version 3.13). Currently a sequence like:
>
>      if (-1 == syscall(__NR_pivot_root, ".", ".")) {
>          perror("pivot_root");
>          return EXIT_FAILURE;
>      }
>
>      if (-1 == umount2(".", MNT_DETACH)) {
>          perror("umount");
>          return EXIT_FAILURE;

Given the comment, you don't know what '.' refers to in the umount2 call 
above.  In fact, I think you're actually detaching the wrong thing, 
leaving possible security issues.

See:

https://github.com/sandstorm-io/sandstorm/blob/master/src/sandstorm/supervisor-main.c%2B%2B#L922

for a program that does this more carefully.

--Andy
