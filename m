Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaEZIus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:50:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaEZIur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:50:47 -0400
Date: Mon, 26 May 2014 10:50:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
cc: Aravinda Prasad <aravinda@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 03/16] kgr: initial code
In-Reply-To: <537B3E43.5070306@suse.cz>
Message-ID: <alpine.LNX.2.00.1405261049390.12047@pobox.suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-4-git-send-email-jslaby@suse.cz> <53733746.1040200@linux.vnet.ibm.com> <537B3E43.5070306@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Jiri Slaby wrote:

> Yes, this is a problem I was thinking of in another context yesterday.
> Patching ->read or any other file_openrations which hold state over
> user<->kernel switches may be a potential threat like above. The same as
> in other implementations of live patching IMO. I put that on a TODO
> checklist for creating patches. This has to be investigated manually
> when creating a patch.

Another thing that has to be handled very carefully is patching functions 
which are using self-modifying code (static keys), to make sure that the 
logic is not switched in the new function.

-- 
Jiri Kosina
SUSE Labs
