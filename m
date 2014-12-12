Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967796AbaLLMx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:53:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27873 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967631AbaLLMxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:53:25 -0500
Date: Fri, 12 Dec 2014 15:52:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Krzysztof Konopko <kris@konagma.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
Message-ID: <20141212125255.GB4921@mwanda>
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
 <548A2E7A.4010303@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548A2E7A.4010303@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 05:53:30PM -0600, Larry Finger wrote:
> On 12/11/2014 04:23 PM, Krzysztof Konopko wrote:
> >Some struct fields in wifi.h are meant to be __le16 bu were declared as
> >unsigned short.  This was reported by sparse:
> >
> >   rtw_wlan_util.c:538:24: warning: cast to restricted __le16
> >   rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
> >   rtw_wlan_util.c:1546:25: warning: cast to restricted __le16
> >
> >This patch changes declared types of the struct fields involved.
> >
> >Signed-off-by: Krzysztof Konopko <kris@konagma.com>
> >---
> >  drivers/staging/rtl8723au/include/wifi.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
> >index fd3da3b..8a2adc5 100644
> >--- a/drivers/staging/rtl8723au/include/wifi.h
> >+++ b/drivers/staging/rtl8723au/include/wifi.h
> >@@ -28,7 +28,7 @@
> >  struct AC_param {
> >  	unsigned char		ACI_AIFSN;
> >  	unsigned char		CW;
> >-	unsigned short	TXOP_limit;
> >+	__le16			TXOP_limit;
> >  }  __packed;
> >
> >  struct WMM_para_element {
> >@@ -39,9 +39,9 @@ struct WMM_para_element {
> >
> >  struct ADDBA_request {
> >  	unsigned char		dialog_token;
> >-	unsigned short	BA_para_set;
> >+	__le16		BA_para_set;
> >  	unsigned short	BA_timeout_value;
> >-	unsigned short	BA_starting_seqctrl;
> >+	__le16		BA_starting_seqctrl;
> >  }  __packed;
> 
> This fix may make the sparse warnings go away, but I think it
> introduces new bugs.

This kind of change, doesn't change the compiled code only how Sparse
sees it.  It can't introduce bugs.

But it may well be that the calls to le16_to_cpu() should be removed.  I
looked at it a bit but I don't know.

regards,
dan carpenter

