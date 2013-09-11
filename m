Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3IKReo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:34:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47852 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab3IKRem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:34:42 -0400
Message-ID: <1378920873.2257.353.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 04/16] integrity: Allow digital signature verification
 with a given keyring ptr
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com
Date: Wed, 11 Sep 2013 13:34:33 -0400
In-Reply-To: <1378849471-10521-5-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
	 <1378849471-10521-5-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091117-5806-0000-0000-000022B39BFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 17:44 -0400, Vivek Goyal wrote:
> Currently digital signature verification code assumes that it can be
> used only with 3 keyrings. IMA, EVM and MODULE keyring. Provide another
> variant where one can pass in a pointer to keyring (struct key *), and
> integrity code can try to find key in that keyring and verify signature.
> 
> This will be useful at two places.
> 
> - elf binary loader can use system keyring and call into integrity
>   subsystem for signature verification.
> - In later patches I am extending keyctl() to allow signature of
>   a user buffer against specified keyring. That logic can make use
>   of this code too.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

My original thought was to use the system keyring, in lieu of having the
multiple keyrings.  Unfortunately, the scope of a key's usage needs to
be limited, which can not be done safely with a single keyring.

Mimi

