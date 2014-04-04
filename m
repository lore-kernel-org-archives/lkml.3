Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaDDDU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:20:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41454 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaDDDUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:20:23 -0400
Message-ID: <533E259B.4030507@oracle.com>
Date: Thu, 03 Apr 2014 23:23:07 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: srostedt@redhat.com
CC: xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
Subject: Xen 32-bit PV regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

Looks like commit 198d208df (x86: Keep thread_info on thread stack in 
x86_32) broke Xen's 32-bit PV guests.

I poked a little at it and it seems that at least the ifdef in 
xen_cpu_up() needs to be adjusted to set up kernel_stack --- that allows 
CPUs to get going. This is not enough though (not particularly 
surprisingly) and we die a little later with #GPF in xen_iret.

-boris
