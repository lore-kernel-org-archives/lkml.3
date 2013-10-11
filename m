Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3JKJ3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:29:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33673 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3JKJ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:29:31 -0400
Date: Fri, 11 Oct 2013 11:28:37 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: ebiederm@xmission.com, hbabu@us.ibm.com, hpa@linux.intel.com,
        keescook@chromium.org, vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: david.vrabel@citrix.com, jbeulich@suse.com, keir@xen.org,
        xen-devel@lists.xen.org
Subject: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you explain why do you clear all registers just before jumping
into purgatory (please look into arch/x86/kernel/relocate_kernel_64.S
for more details)? There is no any single word about that. I do not
count comment which states what is going on. purgatory on entry does
not assume any value in registers. Are you going to use that feature
for something in the future (e.g. to differentiate between callers
and/or Linux versions if it be needed)?

By the way, interestingly it is not done if preserve_context is in force.

Daniel
