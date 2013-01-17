Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3AQPWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:22:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab3AQPWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:22:35 -0500
Date: Thu, 17 Jan 2013 10:21:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130117152141.GB12165@redhat.com>
References: <1358344859.4593.66.camel@falcor1>
 <20130116144836.GB29845@redhat.com>
 <1358350391.4593.112.camel@falcor1>
 <20130116163453.GD29845@redhat.com>
 <1358359715.4593.146.camel@falcor1>
 <20130116182804.GF29845@redhat.com>
 <1358364290.4593.178.camel@falcor1>
 <20130116215341.GA4222@redhat.com>
 <CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
 <CALLzPKZhsKnzjLE_wbm=qYZcaFiKq+5LE6G1ZaphutCGFSFV7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKZhsKnzjLE_wbm=qYZcaFiKq+5LE6G1ZaphutCGFSFV7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 05:06:09PM +0200, Kasatkin, Dmitry wrote:

[..]
> One important thing to mention.
> Protecting ELF-only does not help too much in protecting the system.
> There are plenty of init, upstart and systemd scripts which must be
> verified as well. IMA does it.

Actually that would be a different requirement altogether. I am not
trying to verify all the processes started by root. I am just trying
to sign and verify signature of select user process and if signature
are verified, kernel grants those processes extra capability and allow
calling sys_kexec() when secureboot is enabled.

So for my use case, I don't care if there are so many other unsigned
processes running in the system.

Thanks
Vivek
