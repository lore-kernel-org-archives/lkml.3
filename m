Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaFDTFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:05:24 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62664 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaFDTFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:05:22 -0400
Message-ID: <538F6DEB.2000601@redhat.com>
Date: Wed, 04 Jun 2014 21:05:15 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Venkatesh Srinivas <venkateshs@google.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,
        JBottomley@parallels.com, stable@vger.kernel.org,
        Venkatesh Srinivas <vsrinivas@ops101.org>
Subject: Re: [PATCH v3 5/6] virtio-scsi: fix various bad behavior on aborted
 requests
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>	<1401881699-1456-6-git-send-email-pbonzini@redhat.com> <CAHdzE-8KoMrg_jSuj-F9c=HnapCiLCg9bKCifduTaxx-DAJZRw@mail.gmail.com>
In-Reply-To: <CAHdzE-8KoMrg_jSuj-F9c=HnapCiLCg9bKCifduTaxx-DAJZRw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/06/2014 19:29, Venkatesh Srinivas ha scritto:
> Do you really want to poll the request VQs for completions if the TMF
> was rejected?

I wasn't sure, but bugs in this path are hard enough that I preferred 
the safer patch.

> TMF ABORT may return FUNCTION REJECTED if the command to abort
> completed before the device saw the TMF ABORT message, for example. In
> such cases, this would
> unnecessarily lengthen the EH path.

The cost of virtscsi_poll_requests should be nothing compared to the 
delay between the timeout and the invocation of the delayed_work, no?

Paolo
