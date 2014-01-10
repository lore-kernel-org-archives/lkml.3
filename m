Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaAJJkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:40:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26579 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaAJJkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:40:41 -0500
Date: Fri, 10 Jan 2014 12:40:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140110094015.GU30234@mwanda>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
 <20140109073949.GR30234@mwanda>
 <540ecdf5cf6b47d79583f4f97788e3f0@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140109200921.GT30234@mwanda>
 <1f59f9753bec413888cc96972e0f2dd2@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f59f9753bec413888cc96972e0f2dd2@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 09:05:05PM +0000, KY Srinivasan wrote:
> > 
> > We've had this discussion before where you urge me to trust the host...
> 
> I am just implementing the protocol specification given by the host. If I cannot trust the
> specified protocol, I am not sure what else can be done here.

I'm sorry I got too upset and we're not communicating correctly.

Anyway, looking at the code, there is actually locking in
process_chn_event() which protect ->fcopy_context.  It's still sucky to
only store the last message in the queue but that's ok.

+static int fcopy_handle_handshake(int op)
+{
+       int ret = 1;
+
+       pr_info("FCP: user-mode registering done.\n");
+       fcopy_transaction.active = false;
+       set_channel_read_state((struct vmbus_channel *)
+                               fcopy_transaction.fcopy_context,
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Dereferenced inside the call to set_channel_read_state()

+                               true);
+
+       if (fcopy_transaction.fcopy_context)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Checked for NULL.

+               hv_fcopy_onchannelcallback(fcopy_transaction.fcopy_context);
+
+       in_hand_shake = false;
+       return ret;
+}

regards,
dan carpenter

