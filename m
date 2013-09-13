Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3IMPhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:37:43 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3352 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab3IMPhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:37:41 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <52333139.6020203@broadcom.com>
Date: Fri, 13 Sep 2013 17:37:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Matt Fleming" <matt.fleming@intel.com>
cc: linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: access efi variables
X-WSS-ID: 7E2DEFC50UO6908623-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to obtain a uefi variable so I went looking at the API in 
include/linux/efi.h. I found the following definition:

/*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
  * space in each part of the structure,
  * and we use a page for reading/writing.
  */

struct efi_variable {
	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
	efi_guid_t    VendorGuid;
	unsigned long DataSize;
	__u8          Data[1024];
	efi_status_t  Status;
	__u32         Attributes;
} __attribute__((packed));

But according to the specs the variable I need to obtain is 2k bytes. 
Should I expect trouble :-p

Regards,
Arend

