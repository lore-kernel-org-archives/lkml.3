Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbaKUI4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:56:18 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57353 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaKUI4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:56:17 -0500
Date: Fri, 21 Nov 2014 00:56:11 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/19] input: cyapa: instruction of cyapa patches
Message-ID: <20141121085611.GA21999@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, linux-kernel@vger.kernel.org
References: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Wed, Nov 19, 2014 at 04:37:32PM +0800, Dudley Du wrote:
> V11 patches have below main updates compared with v10 patches:
> 1) Add add acpi device id supported for old gen3 and new gen5 trackpad devices.
> 2) Fix the unable to update firmware issue when cyapa_open is not called
>    which means the irq for firwmare update process is not enabled. This fix
[]

I am having a problem with an older patch which is currently in
linux-next (20141120) and which might be related to this new patch set.

On an Acer C720 if a suspend and resume is performed the touchpad will
stop working.  If the cyapa driver is reloaded it will begin working
again.

I performed a bisect and found that the following patch was the cause.

  From b1cfa7b4388285c0f0b486f152ab0cb18612c779 Mon Sep 17 00:00:00 2001
  From: Dudley Du <dudley.dulixin@gmail.com>
  Date: Sun, 9 Nov 2014 12:36:34 -0800
  Subject: [PATCH] Input: cyapa - switch to using managed resources
  
  Use of managed resources simplifies error handling and device removal
  code.
  
  Signed-off-by: Dudley Du <dudl@cypress.com>
  [Dmitry: added open/close methods so cyapa_remove is no longer needed.]
  Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

If I can provide any other information that would be of help let me know.
I will try out your new patchset if I get a chance.

-- 
- Jeremiah Mahler
