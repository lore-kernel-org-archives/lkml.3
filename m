Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaFJNS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:18:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8541 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaFJNSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:18:24 -0400
X-IronPort-AV: E=Sophos;i="4.98,1009,1392163200"; 
   d="scan'208";a="141583562"
Message-ID: <53970598.6090008@citrix.com>
Date: Tue, 10 Jun 2014 14:18:16 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3.4 82/88] xen/setup: Populate freed MFNs from non-RAM
 E820 entries and gaps to E820 RAM
References: <20140610002424.500996570@linuxfoundation.org> <20140610002427.192691272@linuxfoundation.org> <5396CACF.6050801@citrix.com> <20140610093011.GL15989@olila.local.net-space.pl>
In-Reply-To: <20140610093011.GL15989@olila.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/14 10:30, Daniel Kiper wrote:
> On Tue, Jun 10, 2014 at 10:07:27AM +0100, David Vrabel wrote:
>> On 10/06/14 01:25, Greg Kroah-Hartman wrote:
>>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>>
>> This is a new feature and not a bug fix.  I don't think it (and patches
>> 83-85) are suitable for stable.
> 
> IIRC, this is the main patch fixing dom0 memory looses.
> Earlier patches are preparatory stuff and later ones are
> fixing bugs introduced by this patch and others. Konrad and I
> picked only minimal set of patches to fix that issue in 3.4.

This is not a bug fix.  dom0 was previously required to use the balloon
driver to recover memory freed during setup.  This was annoying but not
a bug.

This patches makes significant changes to how much memory dom0 ends up.
 Depending on hardware, the dom0_mem option, and the (non)use of the
balloon driver  applying this could result is between 1 - 3 GB of
additional memory allocated to dom0.  This could result in there being
insufficient host memory available to start a VM.

Please do not add to 3.4.y.

David
