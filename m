Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955Ab3BNUwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:52:19 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:54429 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990Ab3BNUwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:52:17 -0500
Message-ID: <1360875084.3524.695.camel@falcor1.watson.ibm.com>
Subject: Re: [RFC PATCH 0/6][v3] ima: Support a mode to appraise signed
 files only
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com
Date: Thu, 14 Feb 2013 15:51:24 -0500
In-Reply-To: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021420-7408-0000-0000-00000CD6A950
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:55 -0500, Vivek Goyal wrote:
> Hi,
> 
> Currently ima appraises all the files as specified by the rule.

Currently IMA appraises files based on policy.

>  So
> if one wants to create a system where only few executables are
> signed, that system will not work with IMA.

This statement misrepresents the IMA policy.  You can definitely define
a policy that only measures/appraises a few specific files.  In your
usecase scenario, you are not willing to rely on LSM labels.  Policy
rules can also be based on file owner.  We could also add support for
gid.

> With secureboot, one needs to disable kexec so that unsigned kernels
> can't be booted. To avoid this problem, it was proposed that sign
> /sbin/kexec binary and if signatures are verified successfully, give
> an special capability to the /sbin/kexec process. And in secureboot
> mode processes with that special capability can invoke sys_kexec()
> system call.

Please add here that you then rely on /sbin/kexec to verify the
integrity of the kernel image.

thanks,

Mimi

