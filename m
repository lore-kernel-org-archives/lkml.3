Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445Ab3DDQAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:00:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:10887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761335Ab3DDQAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:00:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,410,1363158000"; 
   d="scan'208";a="289406298"
From: "Luck, Tony" <tony.luck@intel.com>
To: Richard Weinberger <richard@nod.at>,
        "Fleming, Matt" <matt.fleming@intel.com>
CC: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>
Subject: RE: [PATCH 1/2] efivars: Check max_size only if it is non-zero.
Thread-Topic: [PATCH 1/2] efivars: Check max_size only if it is non-zero.
Thread-Index: AQHOMTSl62+/asvqVE6P9QwwhLfZcJjGNk8Q
Date: Thu, 4 Apr 2013 16:00:36 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com>
References: <1365080500-13677-1-git-send-email-richard@nod.at>
In-Reply-To: <1365080500-13677-1-git-send-email-richard@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some (broken?) EFI implementations return always a MaximumVariableSize of 0,
> check against max_size only if it is non-zero.

The spec doesn't say that zero has any special meaning - so if an implementation
returns max_size == 0 but lets you set a variable to a size > 0, then I don't think
there is a need for parentheses or a "?" in this commit comment.

But if Linux silently accepts such broken EFI, then there is no feedback loop
to let EFI implementations know that they are broken.  In other areas we have
thrown out messages about firmware being broken ... perhaps:

	if (max_size == 0)
		printk_once("Broken EFI implementation is returning MaxVariableSize=0\n");

would help? After all there probably *is* a maximum size - but EFI isn't telling us what it is.

-Tony
