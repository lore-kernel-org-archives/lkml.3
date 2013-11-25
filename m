Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3KYVct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:32:49 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:33772 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3KYVcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:32:45 -0500
Message-ID: <1385415160.2357.17.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL v3] ima: bug fixes for Linus
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>, James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 25 Nov 2013 16:32:40 -0500
In-Reply-To: <CAKocOOPeiZsN8WGS5sQu5bOmc8JUGi=UqZgC9Afw0gTGpRh9CA@mail.gmail.com>
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org>
	 <1385338461.5402.3.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org>
	 <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1385387470.2488.2.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org>
	 <52939AEE.5070809@polito.it>
	 <1385411631.2357.5.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CAKocOOPeiZsN8WGS5sQu5bOmc8JUGi=UqZgC9Afw0gTGpRh9CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112521-1542-0000-0000-0000039BF66B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 13:54 -0700, Shuah Khan wrote:
> Mimi,
> 
> Do you have fix for the following build error as well.
> 
>   CC      security/integrity/digsig.o
> security/integrity/digsig.c:70:5: error: redefinition of
> ‘integrity_init_keyring’
>  int integrity_init_keyring(const unsigned int id)
>      ^
> In file included from security/integrity/digsig.c:22:0:
> security/integrity/integrity.h:149:12: note: previous definition of
> ‘integrity_init_keyring’ was here
>  static int integrity_init_keyring(const unsigned int id)
>             ^
> security/integrity/integrity.h:149:12: warning:
> ‘integrity_init_keyring’ defined but not used [-Wunused-function]
> make[2]: *** [security/integrity/digsig.o] Error 1
> make[1]: *** [security/integrity] Error 2
> make: *** [security] Error 2
> 
> I noticed the problem in linux-next and sent patch to fix it:
> 
> https://lkml.org/lkml/2013/11/8/441
> 
> I think It has been noticed in 3.13-rc1 as well.

Thanks, Shuah.  As much as I wanted to extend the UEFI secure boot
signature chain of trust to IMA-appraisal, there are still a couple of
trusted keyring issues that need to be addressed.  For now, Linus has
reverted this patch.

thanks,

Mimi

