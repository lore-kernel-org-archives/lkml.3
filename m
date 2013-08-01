Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3HAOlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:41:49 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:44052 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755872Ab3HAOlr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:41:47 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(51704005)(199002)(189002)(377454003)(13464003)(16406001)(19580395003)(81542001)(33646001)(51856001)(74316001)(81342001)(53806001)(66066001)(80022001)(54356001)(56776001)(83322001)(49866001)(65816001)(46102001)(80976001)(47976001)(74706001)(19580405001)(56816003)(76482001)(74662001)(4396001)(76576001)(74876001)(54316002)(77096001)(74502001)(47736001)(76786001)(59766001)(47446002)(76796001)(63696002)(74366001)(77982001)(69226001)(83072001)(50986001)(79102001)(31966008)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Tools: hv: in kvp_set_ip_info free mac_addr right after
 usage
Thread-Topic: [PATCH] Tools: hv: in kvp_set_ip_info free mac_addr right
 after usage
Thread-Index: AQHOjrbo13iso8fTc0akvS5He6Q3F5mAa0xA
Date: Thu, 1 Aug 2013 14:35:36 +0000
Message-ID: <847c519c55cc4479a6f47e7dc43a8a90@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1375361890-15339-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1375361890-15339-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0925081676
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, August 01, 2013 8:58 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH] Tools: hv: in kvp_set_ip_info free mac_addr right after usage
> 
> ... to simplify error path in upcoming changes.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 418ac55..ba075e5 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1299,6 +1299,7 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
>  	}
> 
>  	error = kvp_write_file(file, "HWADDR", "", mac_addr);
> +	free(mac_addr);
>  	if (error)
>  		goto setval_error;
> 
> @@ -1344,7 +1345,6 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
>  		goto setval_error;
> 
>  setval_done:
> -	free(mac_addr);
>  	fclose(file);
> 
>  	/*
> @@ -1358,7 +1358,6 @@ setval_done:
> 
>  setval_error:
>  	syslog(LOG_ERR, "Failed to write config file");
> -	free(mac_addr);
>  	fclose(file);
>  	return error;
>  }
> 
> 



