Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030359Ab3DSMZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:25:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030195Ab3DSMZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:25:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
Date: Fri, 19 Apr 2013 14:25:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <201304191213.48631.arnd@arndb.de> <517124D6.7090008@metafoo.de>
In-Reply-To: <517124D6.7090008@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191425.44963.arnd@arndb.de>
X-Provags-ID: V02:K0:sdaGwQu3qqMzxs14BjpkHaeqT+IcR8TCWt5Y8uw7cW9
 qfwA3hyfY3ZKzkxMOu7R4hpWD7OEHvwjufoQmNW8EY70Yx0D5/
 SwgPt+tftdweIAg5oYHMu0cS7RMFcx7IU8uWO1tAzYpNRbr1ev
 e7ybS5goxszG3bGNwRj3LWuxgZeL7OvXjD+OYsTTgbGonkpyAE
 nHyLIqvToAQJUWbSmA3lFCHqE4qVD+5Wpfnzaouez40s5zi7F+
 LFXhQEqD5OAGTRm5EHkp2YFdodjUebWLCiVBDI7qsr+javCJLM
 qXW5pqD8eC3cBN9Si+Id2VHpDROSzw8EvDI36b3bWxXN14G/4r
 Vdyro2bPMCpG7AmqumYg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Lars-Peter Clausen wrote:
> Well, It's not only about the of_dma struct, e.g. the of_dma's of_dma_data
> field usually points to some driver allocated data. If we do not block in
> of_dma_controller_free() this data might be freed while the controller is
> still in use.

Right, makes sense. This could of course be worked around using a destructor
in the of_dma struct, but your approach is much simpler.

	Arnd
