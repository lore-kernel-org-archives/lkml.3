Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaLVOsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:48:19 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59462 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaLVOsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:48:17 -0500
Date: Mon, 22 Dec 2014 14:48:14 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: System automatically wakes up because of Intel Rapid Start
 Technology
Message-ID: <20141222144814.GA11844@srcf.ucam.org>
References: <9927036.n7iZq92iLW@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9927036.n7iZq92iLW@xps13>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I suspect I know what's going on here - the firmware is probably 
not cancelling the wakeup timer on resume, and on the second suspend 
makes the assumption that the OS has set the wakeup timer and so decides 
that the user wants the machine to wake up. We could add workaround code 
to the irst driver to handle that case, but that would involve it being 
rather more friendly with the system clock than we want. I think the 
right fix is probably to have the rtc driver reset the alarm on resume.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
