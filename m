Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3KYUyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:54:09 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:64278 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KYUyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:54:06 -0500
MIME-Version: 1.0
In-Reply-To: <1385411631.2357.5.camel@dhcp-9-2-203-236.watson.ibm.com>
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
Date: Mon, 25 Nov 2013 13:54:05 -0700
Message-ID: <CAKocOOPeiZsN8WGS5sQu5bOmc8JUGi=UqZgC9Afw0gTGpRh9CA@mail.gmail.com>
Subject: Re: [GIT PULL v3] ima: bug fixes for Linus
From: Shuah Khan <shuahkhan@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>, James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi,

Do you have fix for the following build error as well.

  CC      security/integrity/digsig.o
security/integrity/digsig.c:70:5: error: redefinition of
‘integrity_init_keyring’
 int integrity_init_keyring(const unsigned int id)
     ^
In file included from security/integrity/digsig.c:22:0:
security/integrity/integrity.h:149:12: note: previous definition of
‘integrity_init_keyring’ was here
 static int integrity_init_keyring(const unsigned int id)
            ^
security/integrity/integrity.h:149:12: warning:
‘integrity_init_keyring’ defined but not used [-Wunused-function]
make[2]: *** [security/integrity/digsig.o] Error 1
make[1]: *** [security/integrity] Error 2
make: *** [security] Error 2

I noticed the problem in linux-next and sent patch to fix it:

https://lkml.org/lkml/2013/11/8/441

I think It has been noticed in 3.13-rc1 as well.

-- Shuah

On Mon, Nov 25, 2013 at 1:33 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Hi James,
>
> Included in this pull request, is Roberto's updated patch.  I've
> included a Changelog.
>
> The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:
>
>   Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus
>
> for you to fetch changes up to dbc335d2dc3c437649eb6b39f4e9aee2a13eb0af:
>
>   ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-25 15:05:33 -0500)
>
> thanks,
>
> Mimi
>
> ----------------------------------------------------------------
> Roberto Sassu (3):
>       ima: do not include field length in template digest calc for ima template
>       ima: do not send field length to userspace for digest of ima template
>       ima: make a copy of template_fmt in template_desc_init_fields()
>
>  security/integrity/ima/ima.h              |  6 ++++--
>  security/integrity/ima/ima_api.c          |  1 +
>  security/integrity/ima/ima_crypto.c       | 17 ++++++++++++-----
>  security/integrity/ima/ima_fs.c           | 14 +++++++++++---
>  security/integrity/ima/ima_template.c     | 21 ++++++++++++++-------
>  security/integrity/ima/ima_template_lib.c |  6 +++++-
>  6 files changed, 47 insertions(+), 18 deletions(-)
>
> ----------------------------------------------------------------
> Roberto Sassu (3):
>       ima: do not include field length in template digest calc for ima
> template
>       ima: do not send field length to userspace for digest of ima
> template
>       ima: make a copy of template_fmt in template_desc_init_fields()
>
>  security/integrity/ima/ima.h              |  6 ++++--
>  security/integrity/ima/ima_api.c          |  1 +
>  security/integrity/ima/ima_crypto.c       | 17 ++++++++++++-----
>  security/integrity/ima/ima_fs.c           | 14 +++++++++++---
>  security/integrity/ima/ima_template.c     | 21 ++++++++++++++-------
>  security/integrity/ima/ima_template_lib.c |  6 +++++-
>  6 files changed, 47 insertions(+), 18 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
