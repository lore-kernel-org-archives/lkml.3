Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3JXQg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:36:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34047 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab3JXQgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:36:54 -0400
X-Sasl-enc: c5Z5uUGtt3MiuUTDrH7DWfoBBJXjYwbs3xbySjMr6K3K 1382632613
Date: Thu, 24 Oct 2013 14:36:51 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Felipe Pena <felipensp@gmail.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: Fix wrong assignment
Message-ID: <20131024163651.GB3851@khazad-dum.debian.net>
References: <1382136067-3888-1-git-send-email-felipensp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382136067-3888-1-git-send-email-felipensp@gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Felipe Pena wrote:
> In the thermal_init function when checking for thinkpad_id.ec_model,
> the 'ta2' variable is being OR'd when acpi_ec_read call succeeds,
> on fail it is setting 0 to 'ta1' variable instead.
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>

NAK.

ta1 == 0 implies malfunction on the direct-from-EC temperature reading,
which is what the code wants to signal.  The code is correct as is.

Do not merge this patch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
