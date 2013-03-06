Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3CFAWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:22:38 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37040 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3CFAWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:22:37 -0500
Message-ID: <51368C45.40303@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 16:22:29 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp> <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp> <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51367104.5050200@linux.vnet.ibm.com> <20130305224432.GD27022@pd.tnic>
In-Reply-To: <20130305224432.GD27022@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030600-9360-0000-0000-0000112F28AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you also add the following to your .config:

	CONFIG_ACPI_DEBUG=y

and boot with these on the kernel command-line:

	acpi.debug_layer=0xffffffff acpi.debug_level=0x2

I _think_ that'll shed some light on exactly which ACPI table is being
parsed when the BUG_ON() trips.  That will hopefully let other folks
reproduce it more easily.


