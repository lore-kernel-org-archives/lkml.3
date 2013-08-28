Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3H1U3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:29:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57601 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab3H1U3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:29:03 -0400
Message-ID: <521E5D58.5070708@zytor.com>
Date: Wed, 28 Aug 2013 13:28:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Memory synchronization vs. interrupt handlers
References: <Pine.LNX.4.44L0.1308281501000.1541-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308281501000.1541-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 12:16 PM, Alan Stern wrote:
> Russell, Peter, and Ingo:
> 
> Can you folks enlighten us regarding this issue for some common 
> architectures?
> 

On x86, IRET is a serializing instruction; it guarantees hard
serialization of absolutely everything.

I would expect architectures that have weak memory ordering to put
appropriate barriers in the IRQ entry/exit code.

	-hpa

