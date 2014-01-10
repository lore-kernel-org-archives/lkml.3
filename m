Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaAJW5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:57:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24392 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaAJW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:57:28 -0500
Message-ID: <52D07AEC.6060209@oracle.com>
Date: Fri, 10 Jan 2014 17:57:48 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: david.vrabel@citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de> <52D036FC.6000308@oracle.com> <20140110213746.GA933@aepfle.de> <52D073F0.5020400@oracle.com> <20140110224927.GA14824@aepfle.de>
In-Reply-To: <20140110224927.GA14824@aepfle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 05:49 PM, Olaf Hering wrote:
> On Fri, Jan 10, Boris Ostrovsky wrote:
>
>> I think we should at clear feature_discard and print an error in the log if
>> *either* of xenbus_gather() calls fail.
> Are you sure about that? AFAIK many other properties are optional as
> well. I dont think there is a formal spec about the discard related
> properties. Should every backend be required to provide all four
> properties?

It's not whether the properties are required or not. It's that they may 
have been set by the admin but we ignored them. I am particularly 
concerned about security setting.

Can you determine from the error whether the call failed or the property 
wasn't available?

Alternatively, we may have to require the toolstack that if 
feature-discard is provided then all three of these are provided as 
well. And then you disable discard on any error.

-boris
