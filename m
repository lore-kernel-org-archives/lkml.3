Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbbAWS1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:27:22 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:59005 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbbAWS1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:27:19 -0500
Message-ID: <54C2926E.1040700@ahsoftware.de>
Date: Fri, 23 Jan 2015 19:26:54 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: provide option to automatically delete the key
 after modules were installed
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <54C21361.1080500@suse.cz> <54C216D8.8040004@ahsoftware.de> <54C21F35.1040206@ahsoftware.de> <54C22891.6070506@suse.cz> <54C233FB.3080309@ahsoftware.de> <54C2367C.4000909@ahsoftware.de> <54C23FE2.9030303@ahsoftware.de>
In-Reply-To: <54C23FE2.9030303@ahsoftware.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.01.2015 um 13:34 schrieb Alexander Holler:

> 4. With some scripting it should be possible to extract the public key
> out of an existing binary kernel. So there is no real need to change the
> already complicated build process which might make it even more
> complicated.

BTW: With "more complicated" I meant that it isn't just done with making 
modules_install depend on the private key. That would end up with the 
following when the public key exist but the private key doesn't:

- kernel is build including the public key
- private key (and thus the public key) will be generated newly
- modules will be installed using a key the kernel doesn't know about

So the solution to just delete both keys looks for me still like the 
most easy and thus preferable way to implement that feature with just a 
few line of changes.

Regards,

Alexander Holler
