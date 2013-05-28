Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab3E1O1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:27:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123Ab3E1O1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:27:53 -0400
Date: Tue, 28 May 2013 16:27:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Ryan <ryanphilips19@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Affine issues
Message-ID: <20130528142752.GA16951@dhcp22.suse.cz>
References: <CANMsd00MEep_+aSfQ7s9ksL=XmzwNtVALN1h0uZzSEQSM_u2FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANMsd00MEep_+aSfQ7s9ksL=XmzwNtVALN1h0uZzSEQSM_u2FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27-05-13 18:41:35, Ryan wrote:
> When do we get the message:
> 
> IRQ79 no longer affine to CPU1
> 
> 
> Is this a hard error?

No.

> As i understand this comes during CPU hotplug.
> 
> Can anyone explain when this happens.

AFAIU this happens when an IRQ is bound to a particular CPU(s) and the
last allowed CPU is offlined. The IRQ handling would be migrated to
another allowed CPU but if there is no such then it has to break the
affinity requirements.

> I am not interrester in IRQ79, But more interested in why this occurs?
> 
> 
> Thanks,
> Ryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
