Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3E1KNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:13:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab3E1KNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:13:47 -0400
Date: Tue, 28 May 2013 12:13:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Christian Ohm <chr.ohm@gmx.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Holtek gaming mouse driver, and the necessity for
 it instead of increasing HID_MAX_USAGES
In-Reply-To: <cover.1369083628.git.chr.ohm@gmx.net>
Message-ID: <alpine.LNX.2.00.1305281210460.3914@pobox.suse.cz>
References: <cover.1369083628.git.chr.ohm@gmx.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013, Christian Ohm wrote:

> Is there any reason why HID_MAX_USAGES shouldn't be more than 12288?  

Well, the reasoning is a mixture of current implementation, and 
reasonability.

- we currently have statically allocated arrays on a per-parser basis, for 
  parsing usages and collection indices. If the number of max usages is 
  going to grow in an uncontrolled manner, we'll have to change the way 
  our parser works (which is not impossible, of course).

- most of the ocurences of huge max usages being presented by the devices 
  have actually turned out to be bogus and could have been fixed by 
  patching the report descriptor in order to reflect the real behavior of 
  the device

Thanks,

-- 
Jiri Kosina
SUSE Labs
