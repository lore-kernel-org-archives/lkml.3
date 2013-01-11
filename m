Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3AKMqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:46:10 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56433 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3AKMqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:46:08 -0500
Message-ID: <1357908362.4146.23.camel@falcor>
Subject: Re: [PATCHv2] Smack: add support for modification of existing rules
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rafal Krypa <r.krypa@samsung.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date: Fri, 11 Jan 2013 07:46:02 -0500
In-Reply-To: <1357843320-11883-2-git-send-email-r.krypa@samsung.com>
References: <1357843320-11883-1-git-send-email-r.krypa@samsung.com>
	 <1357843320-11883-2-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011112-7606-0000-0000-00000751EE85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 19:42 +0100, Rafal Krypa wrote:
> Rule modifications are enabled via /smack/change-rule. Format is as follows:
> "Subject Object rwaxt rwaxt"
> 
> First two strings are subject and object labels up to 255 characters.
> Third string contains permissions to enable.
> Fourth string contains permissions to disable.
> 
> All unmentioned permissions will be left unchanged.
> If no rule previously existed, it will be created.

Changing rules on a running system could affect IMA, if the IMA policy
contains LSM based rules.  Patch "[PATCH 1/9] ima: re-initialize IMA
policy LSM info" addresses this issue.  It assumes existing LSM rules
have not been dropped.

thanks,

Mimi

