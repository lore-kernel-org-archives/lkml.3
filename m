Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaKFFlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:41:18 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62313 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFFlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:41:15 -0500
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Joe Perches <joe@perches.com>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Thread-Topic: [PATCH v2] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Thread-Index: AQHP+OyQ45rVFLm8n0O8xH8v1tFygZxSRm6AgADP3dA=
Date: Thu, 6 Nov 2014 05:41:10 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE950E8B3A0@EU-MBX-02.mgc.mentorg.com>
References: <wrfjy4rxzk5b.fsf@redhat.com>
	 <1415187303-28541-1-git-send-email-sanjeev_sharma@mentor.com>
 <1415207747.6634.15.camel@perches.com>
In-Reply-To: <1415207747.6634.15.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Joe Perches [mailto:joe@perches.com] 
Sent: Wednesday, November 05, 2014 10:46 PM
To: Sharma, Sanjeev
Cc: Larry.Finger@lwfinger.net; Jes.Sorensen@redhat.com; gregkh@linuxfoundation.org; linux-wireless@vger.kernel.org; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging:rtl8723au: core: Fix error reported by checkpatch.

On Wed, 2014-11-05 at 17:05 +0530, Sanjeev Sharma wrote:
> This is a patch to the rtw_cmd.c file that fixes Error reported by 
> checkpatch.

Please run your patches through checkpatch before sending them.

In this patch I am fixing error reported by check patch since Error has higher priority. 

WARNING: suspect code indent for conditional statements (24, 24)
#178: FILE: drivers/staging/rtl8723au/core/rtw_cmd.c:1025:
+			if (check_fwstate(pmlmepriv, _FW_LINKED))
 			LPS_Leave23a(padapter);

Also, there are a couple of different things you changing here.

This should be 2 separate patches.

Ok I will come up with 2 patch separately.

One to use the temporary for:
+	struct rt_link_detect *ldi = &pmlmepriv->LinkDetectInfo;

(and that bit has a defect here:


+	} else {
 		LPS_Leave23a(padapter);
+		}

where the indentation for the last close brace is wrong)

and another for the whitespace only changes


