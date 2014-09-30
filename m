Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaI3KJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:09:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33846 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaI3KJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:09:43 -0400
Date: Tue, 30 Sep 2014 12:09:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20140930100940.GD4639@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
 <1411460354.25617.3.camel@debian>
 <20140929120546.GB6495@pd.tnic>
 <1412037578.21488.11.camel@debian>
 <20140930072553.GA4639@pd.tnic>
 <1412070991.16556.12.camel@cyc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412070991.16556.12.camel@cyc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 05:56:31PM +0800, Chen Yucong wrote:
> I just clear it to avoid that the mce_log() call logs the above
> threshold event again in machine_check_poll().

Ok, that's a good point, please put it in the commit message.

> It is just used for scanning other banks for recording other valid
> error information.

This is actually not what we want - we want to log the errors which
cause the overflow first and then the rest. So you don't need the goto
but simply have the machine_check_poll() at the end.

Now let me repeat my question: how are you testing your patches?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
