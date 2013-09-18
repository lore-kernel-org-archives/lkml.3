Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3IRNwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:52:02 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43421 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3IRNwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:52:01 -0400
Date: Wed, 18 Sep 2013 15:51:56 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Markos Chandras <Markos.Chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Subject: Re: [PATCH v2] MIPS: ath79: Avoid using unitialized 'reg' variable
Message-ID: <20130918135156.GO22468@linux-mips.org>
References: <1377082042-4219-1-git-send-email-markos.chandras@imgtec.com>
 <20130903133839.GA10563@linux-mips.org>
 <5225EC3B.1070701@imgtec.com>
 <20130918134533.GN22468@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918134533.GN22468@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 03:45:33PM +0200, Ralf Baechle wrote:

> So here's a small test case to demonstrate the issue:
> 
> /*
>  * Definition of BUG taken from asm-generic/bug.h for the CONFIG_BUG=n case
>  */
> #define BUG() 	do {} while(0)
> 
> int foo(int arg)
> {
> 	int res;
> 
> 	if (arg == 1)
> 		res = 23;
> 	else if (arg -= 2)

I fatfingered the testcase while editing the email.  this line of course
is "else if (arg == 2)"

  Ralf
