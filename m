Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaATICq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:02:46 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46260 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaATICn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:02:43 -0500
MIME-Version: 1.0
In-Reply-To: <58de05792684431ba0ba08e26a622a51@BY2PR03MB299.namprd03.prod.outlook.com>
References: <CACPM=kWdKX2Ku0Z6zcsyXnadH0fKwa+iUZRTJDA94Z=5_i10Yw@mail.gmail.com>
	<01ff5578c641425bbc35ec186fd13b58@BL2PR03MB291.namprd03.prod.outlook.com>
	<CACPM=kX8j1KUZ5ARnvyuDHNiYXb_BrCjeWprZnnSO=ugPpA_qA@mail.gmail.com>
	<bd20f27a9bb14279b2cc2c7816bd5d5f@BY2PR03MB299.namprd03.prod.outlook.com>
	<CACPM=kWx-tdgPB3b71-wF-v9CWbQoGxMSTYs+0=t7HrWG=J9OA@mail.gmail.com>
	<58de05792684431ba0ba08e26a622a51@BY2PR03MB299.namprd03.prod.outlook.com>
Date: Mon, 20 Jan 2014 09:02:41 +0100
X-Google-Sender-Auth: TyYL-GqNOqJVhwxEX_CrXegAPxY
Message-ID: <CACPM=kUVnKRCN4t5grE1kcfpd87MXfMyHpJ6AE6gp5zFSKKOAw@mail.gmail.com>
Subject: Re: [PATCH v2] Adding hyperv.h to uapi headers
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/20 KY Srinivasan <kys@microsoft.com>:
>
>
>> -----Original Message-----
>> From: gurligebis@gmail.com [mailto:gurligebis@gmail.com] On Behalf Of Bjarke
>> Istrup Pedersen
>> Sent: Sunday, January 19, 2014 11:46 AM
>> To: KY Srinivasan
>> Cc: Linux Kernel Mailing List; Haiyang Zhang
>> Subject: Re: [PATCH v2] Adding hyperv.h to uapi headers
>>
>> 2014/1/19 KY Srinivasan <kys@microsoft.com>:
>> >
>> >
>> >> -----Original Message-----
>> >> From: gurligebis@gmail.com [mailto:gurligebis@gmail.com] On Behalf Of
>> Bjarke
>> >> Istrup Pedersen
>> >> Sent: Sunday, January 19, 2014 2:15 AM
>> >> To: KY Srinivasan
>> >> Cc: Linux Kernel Mailing List; Haiyang Zhang
>> >> Subject: Re: [PATCH v2] Adding hyperv.h to uapi headers
>> >>
>> >> 2014/1/19 KY Srinivasan <kys@microsoft.com>:
>> >> >
>> >> >
>> >> >> -----Original Message-----
>> >> >> From: gurligebis@gmail.com [mailto:gurligebis@gmail.com] On Behalf Of
>> >> Bjarke
>> >> >> Istrup Pedersen
>> >> >> Sent: Saturday, January 18, 2014 4:23 PM
>> >> >> To: Linux Kernel Mailing List
>> >> >> Cc: Haiyang Zhang; KY Srinivasan; Bjarke Istrup Pedersen
>> >> >> Subject: Re: [PATCH v2] Adding hyperv.h to uapi headers
>> >> >>
>> >> >> Could any of you Hyper-V developers take a look at this, and see if
>> >> >> this split makes sense to you?
>> >> >
>> >> > Have you compiled the hyper-v drivers with your change. I briefly looked at
>> >> your
>> >> > latest patch but I did not see an include of the user level hyper-V driver in
>> the
>> >> kernel
>> >> > version of the header; or did I miss it. Please compile the drivers and the
>> >> tools/hv/
>> >> > user level daemons to test your patch.
>> >>
>> >> Hey,
>> >>
>> >> I have compiled it, and both the drivers and the userspace deamons
>> >> builds fine :)
>> >> If you look at the patch, on line 134, it includes the uapi header.
>> >>
>> >> Also, which parts of the uapi version header would you like me to move
>> >> to the kernel version? (I'll create a new patch then, with your
>> >> suggestions)
>> >
>> > Which version information are you referring to. I would keep all version
>> information
>> > in the uapi hyperv.h header file. The kernel needs to handle older versions of
>> the daemons.
>>
>> Sorry, I think I worded it wrong :)
>> What I meant is, is the split done in this patch fine with you, or
>> should I move more/less to the UAPI header file?
>
> I think this is fine. You want to send these patches to Greg KH <greg@kroah.com>

Okay, I have added Greg to the CC list :-)

Thanks.

/Bjarke

>
> K. Y
>
>
>>
>> http://marc.info/?l=linux-kernel&m=139008735529658&w=2
>>
>> /Bjarke
>>
>> > Regards,
>> >
>> > K. Y
>> >>
>> >> /Bjarke
>> >>
>> >> > K. Y
>> >> >>
>> >> >> Thanks :)
>> >> >>
>> >> >> /Bjarke
>> >> >>
>> >> >> 2014/1/19 Bjarke Istrup Pedersen <gurligebis@gentoo.org>:
>> >> >> > This patch adds the hyperv.h header to the uapi folder, and adds it to the
>> >> Kbuild
>> >> >> file.
>> >> >> > Doing this enables compiling userspace Hyper-V tools using the installed
>> >> >> headers.
>> >> >> >
>> >> >> > Version 2: Split UAPI parts into new header, instead of duplicating.
>> >> >> >
>> >> >> > Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
>> >> >> > ---
>> >> >> >  include/linux/hyperv.h      | 321 +----------------------------------------
>> >> >> >  include/uapi/linux/Kbuild   |   1 +
>> >> >> >  include/uapi/linux/hyperv.h | 344
>> >> >> ++++++++++++++++++++++++++++++++++++++++++++
>> >> >> >  3 files changed, 347 insertions(+), 319 deletions(-)
>> >> >> >  create mode 100644 include/uapi/linux/hyperv.h
>> >> >> >
>> >> >> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
>> >> >> > index 15da677..167ef47 100644
>> >> >> > --- a/include/linux/hyperv.h
>> >> >> > +++ b/include/linux/hyperv.h
>> >> >> > @@ -25,325 +25,9 @@
>> >> >> >  #ifndef _HYPERV_H
>> >> >> >  #define _HYPERV_H
>> >> >> >
>> >> >> > -#include <linux/types.h>
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Framework version for util services.
>> >> >> > - */
>> >> >> > -#define UTIL_FW_MINOR  0
>> >> >> > -
>> >> >> > -#define UTIL_WS2K8_FW_MAJOR  1
>> >> >> > -#define UTIL_WS2K8_FW_VERSION     (UTIL_WS2K8_FW_MAJOR << 16
>> |
>> >> >> UTIL_FW_MINOR)
>> >> >> > -
>> >> >> > -#define UTIL_FW_MAJOR  3
>> >> >> > -#define UTIL_FW_VERSION     (UTIL_FW_MAJOR << 16 |
>> UTIL_FW_MINOR)
>> >> >> > -
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Implementation of host controlled snapshot of the guest.
>> >> >> > - */
>> >> >> > -
>> >> >> > -#define VSS_OP_REGISTER 128
>> >> >> > -
>> >> >> > -enum hv_vss_op {
>> >> >> > -       VSS_OP_CREATE = 0,
>> >> >> > -       VSS_OP_DELETE,
>> >> >> > -       VSS_OP_HOT_BACKUP,
>> >> >> > -       VSS_OP_GET_DM_INFO,
>> >> >> > -       VSS_OP_BU_COMPLETE,
>> >> >> > -       /*
>> >> >> > -        * Following operations are only supported with IC version >= 5.0
>> >> >> > -        */
>> >> >> > -       VSS_OP_FREEZE, /* Freeze the file systems in the VM */
>> >> >> > -       VSS_OP_THAW, /* Unfreeze the file systems */
>> >> >> > -       VSS_OP_AUTO_RECOVER,
>> >> >> > -       VSS_OP_COUNT /* Number of operations, must be last */
>> >> >> > -};
>> >> >> > -
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Header for all VSS messages.
>> >> >> > - */
>> >> >> > -struct hv_vss_hdr {
>> >> >> > -       __u8 operation;
>> >> >> > -       __u8 reserved[7];
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Flag values for the hv_vss_check_feature. Linux supports only
>> >> >> > - * one value.
>> >> >> > - */
>> >> >> > -#define VSS_HBU_NO_AUTO_RECOVERY       0x00000005
>> >> >> > -
>> >> >> > -struct hv_vss_check_feature {
>> >> >> > -       __u32 flags;
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -struct hv_vss_check_dm_info {
>> >> >> > -       __u32 flags;
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -struct hv_vss_msg {
>> >> >> > -       union {
>> >> >> > -               struct hv_vss_hdr vss_hdr;
>> >> >> > -               int error;
>> >> >> > -       };
>> >> >> > -       union {
>> >> >> > -               struct hv_vss_check_feature vss_cf;
>> >> >> > -               struct hv_vss_check_dm_info dm_info;
>> >> >> > -       };
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * An implementation of HyperV key value pair (KVP) functionality for
>> Linux.
>> >> >> > - *
>> >> >> > - *
>> >> >> > - * Copyright (C) 2010, Novell, Inc.
>> >> >> > - * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
>> >> >> > - *
>> >> >> > - */
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Maximum value size - used for both key names and value data, and
>> >> includes
>> >> >> > - * any applicable NULL terminators.
>> >> >> > - *
>> >> >> > - * Note:  This limit is somewhat arbitrary, but falls easily within what is
>> >> >> > - * supported for all native guests (back to Win 2000) and what is
>> reasonable
>> >> >> > - * for the IC KVP exchange functionality.  Note that Windows Me/98/95
>> are
>> >> >> > - * limited to 255 character key names.
>> >> >> > - *
>> >> >> > - * MSDN recommends not storing data values larger than 2048 bytes in
>> the
>> >> >> > - * registry.
>> >> >> > - *
>> >> >> > - * Note:  This value is used in defining the KVP exchange message - this
>> >> value
>> >> >> > - * cannot be modified without affecting the message size and
>> compatibility.
>> >> >> > - */
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * bytes, including any null terminators
>> >> >> > - */
>> >> >> > -#define HV_KVP_EXCHANGE_MAX_VALUE_SIZE          (2048)
>> >> >> > -
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Maximum key size - the registry limit for the length of an entry name
>> >> >> > - * is 256 characters, including the null terminator
>> >> >> > - */
>> >> >> > -
>> >> >> > -#define HV_KVP_EXCHANGE_MAX_KEY_SIZE            (512)
>> >> >> > +#include <uapi/linux/hyperv.h>
>> >> >> >
>> >> >> > -/*
>> >> >> > - * In Linux, we implement the KVP functionality in two components:
>> >> >> > - * 1) The kernel component which is packaged as part of the hv_utils
>> driver
>> >> >> > - * is responsible for communicating with the host and responsible for
>> >> >> > - * implementing the host/guest protocol. 2) A user level daemon that is
>> >> >> > - * responsible for data gathering.
>> >> >> > - *
>> >> >> > - * Host/Guest Protocol: The host iterates over an index and expects the
>> >> guest
>> >> >> > - * to assign a key name to the index and also return the value
>> >> corresponding to
>> >> >> > - * the key. The host will have atmost one KVP transaction outstanding at
>> >> any
>> >> >> > - * given point in time. The host side iteration stops when the guest
>> returns
>> >> >> > - * an error. Microsoft has specified the following mapping of key names
>> to
>> >> >> > - * host specified index:
>> >> >> > - *
>> >> >> > - *     Index           Key Name
>> >> >> > - *     0               FullyQualifiedDomainName
>> >> >> > - *     1               IntegrationServicesVersion
>> >> >> > - *     2               NetworkAddressIPv4
>> >> >> > - *     3               NetworkAddressIPv6
>> >> >> > - *     4               OSBuildNumber
>> >> >> > - *     5               OSName
>> >> >> > - *     6               OSMajorVersion
>> >> >> > - *     7               OSMinorVersion
>> >> >> > - *     8               OSVersion
>> >> >> > - *     9               ProcessorArchitecture
>> >> >> > - *
>> >> >> > - * The Windows host expects the Key Name and Key Value to be
>> encoded
>> >> in
>> >> >> utf16.
>> >> >> > - *
>> >> >> > - * Guest Kernel/KVP Daemon Protocol: As noted earlier, we implement
>> all
>> >> of
>> >> >> the
>> >> >> > - * data gathering functionality in a user mode daemon. The user level
>> >> daemon
>> >> >> > - * is also responsible for binding the key name to the index as well. The
>> >> >> > - * kernel and user-level daemon communicate using a connector
>> channel.
>> >> >> > - *
>> >> >> > - * The user mode component first registers with the
>> >> >> > - * the kernel component. Subsequently, the kernel component
>> requests,
>> >> data
>> >> >> > - * for the specified keys. In response to this message the user mode
>> >> >> component
>> >> >> > - * fills in the value corresponding to the specified key. We overload the
>> >> >> > - * sequence field in the cn_msg header to define our KVP message
>> types.
>> >> >> > - *
>> >> >> > - *
>> >> >> > - * The kernel component simply acts as a conduit for communication
>> >> between
>> >> >> the
>> >> >> > - * Windows host and the user-level daemon. The kernel component
>> passes
>> >> up
>> >> >> the
>> >> >> > - * index received from the Host to the user-level daemon. If the index is
>> >> >> > - * valid (supported), the corresponding key as well as its
>> >> >> > - * value (both are strings) is returned. If the index is invalid
>> >> >> > - * (not supported), a NULL key string is returned.
>> >> >> > - */
>> >> >> > -
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Registry value types.
>> >> >> > - */
>> >> >> > -
>> >> >> > -#define REG_SZ 1
>> >> >> > -#define REG_U32 4
>> >> >> > -#define REG_U64 8
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * As we look at expanding the KVP functionality to include
>> >> >> > - * IP injection functionality, we need to maintain binary
>> >> >> > - * compatibility with older daemons.
>> >> >> > - *
>> >> >> > - * The KVP opcodes are defined by the host and it was unfortunate
>> >> >> > - * that I chose to treat the registration operation as part of the
>> >> >> > - * KVP operations defined by the host.
>> >> >> > - * Here is the level of compatibility
>> >> >> > - * (between the user level daemon and the kernel KVP driver) that we
>> >> >> > - * will implement:
>> >> >> > - *
>> >> >> > - * An older daemon will always be supported on a newer driver.
>> >> >> > - * A given user level daemon will require a minimal version of the
>> >> >> > - * kernel driver.
>> >> >> > - * If we cannot handle the version differences, we will fail gracefully
>> >> >> > - * (this can happen when we have a user level daemon that is more
>> >> >> > - * advanced than the KVP driver.
>> >> >> > - *
>> >> >> > - * We will use values used in this handshake for determining if we have
>> >> >> > - * workable user level daemon and the kernel driver. We begin by taking
>> >> the
>> >> >> > - * registration opcode out of the KVP opcode namespace. We will
>> however,
>> >> >> > - * maintain compatibility with the existing user-level daemon code.
>> >> >> > - */
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Daemon code not supporting IP injection (legacy daemon).
>> >> >> > - */
>> >> >> > -
>> >> >> > -#define KVP_OP_REGISTER        4
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Daemon code supporting IP injection.
>> >> >> > - * The KVP opcode field is used to communicate the
>> >> >> > - * registration information; so define a namespace that
>> >> >> > - * will be distinct from the host defined KVP opcode.
>> >> >> > - */
>> >> >> > -
>> >> >> > -#define KVP_OP_REGISTER1 100
>> >> >> > -
>> >> >> > -enum hv_kvp_exchg_op {
>> >> >> > -       KVP_OP_GET = 0,
>> >> >> > -       KVP_OP_SET,
>> >> >> > -       KVP_OP_DELETE,
>> >> >> > -       KVP_OP_ENUMERATE,
>> >> >> > -       KVP_OP_GET_IP_INFO,
>> >> >> > -       KVP_OP_SET_IP_INFO,
>> >> >> > -       KVP_OP_COUNT /* Number of operations, must be last. */
>> >> >> > -};
>> >> >> > -
>> >> >> > -enum hv_kvp_exchg_pool {
>> >> >> > -       KVP_POOL_EXTERNAL = 0,
>> >> >> > -       KVP_POOL_GUEST,
>> >> >> > -       KVP_POOL_AUTO,
>> >> >> > -       KVP_POOL_AUTO_EXTERNAL,
>> >> >> > -       KVP_POOL_AUTO_INTERNAL,
>> >> >> > -       KVP_POOL_COUNT /* Number of pools, must be last. */
>> >> >> > -};
>> >> >> > -
>> >> >> > -/*
>> >> >> > - * Some Hyper-V status codes.
>> >> >> > - */
>> >> >> > -
>> >> >> > -#define HV_S_OK                                0x00000000
>> >> >> > -#define HV_E_FAIL                      0x80004005
>> >> >> > -#define HV_S_CONT                      0x80070103
>> >> >> > -#define HV_ERROR_NOT_SUPPORTED         0x80070032
>> >> >> > -#define HV_ERROR_MACHINE_LOCKED                0x800704F7
>> >> >> > -#define HV_ERROR_DEVICE_NOT_CONNECTED  0x8007048F
>> >> >> > -#define HV_INVALIDARG                  0x80070057
>> >> >> > -#define HV_GUID_NOTFOUND               0x80041002
>> >> >> > -
>> >> >> > -#define ADDR_FAMILY_NONE       0x00
>> >> >> > -#define ADDR_FAMILY_IPV4       0x01
>> >> >> > -#define ADDR_FAMILY_IPV6       0x02
>> >> >> > -
>> >> >> > -#define MAX_ADAPTER_ID_SIZE    128
>> >> >> > -#define MAX_IP_ADDR_SIZE       1024
>> >> >> > -#define MAX_GATEWAY_SIZE       512
>> >> >> > -
>> >> >> > -
>> >> >> > -struct hv_kvp_ipaddr_value {
>> >> >> > -       __u16   adapter_id[MAX_ADAPTER_ID_SIZE];
>> >> >> > -       __u8    addr_family;
>> >> >> > -       __u8    dhcp_enabled;
>> >> >> > -       __u16   ip_addr[MAX_IP_ADDR_SIZE];
>> >> >> > -       __u16   sub_net[MAX_IP_ADDR_SIZE];
>> >> >> > -       __u16   gate_way[MAX_GATEWAY_SIZE];
>> >> >> > -       __u16   dns_addr[MAX_IP_ADDR_SIZE];
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -
>> >> >> > -struct hv_kvp_hdr {
>> >> >> > -       __u8 operation;
>> >> >> > -       __u8 pool;
>> >> >> > -       __u16 pad;
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -struct hv_kvp_exchg_msg_value {
>> >> >> > -       __u32 value_type;
>> >> >> > -       __u32 key_size;
>> >> >> > -       __u32 value_size;
>> >> >> > -       __u8 key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
>> >> >> > -       union {
>> >> >> > -               __u8 value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
>> >> >> > -               __u32 value_u32;
>> >> >> > -               __u64 value_u64;
>> >> >> > -       };
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -struct hv_kvp_msg_enumerate {
>> >> >> > -       __u32 index;
>> >> >> > -       struct hv_kvp_exchg_msg_value data;
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -struct hv_kvp_msg_get {
>> >> >> > -       struct hv_kvp_exchg_msg_value data;
>> >> >> > -};
>> >> >> > -
>> >> >> > -struct hv_kvp_msg_set {
>> >> >> > -       struct hv_kvp_exchg_msg_value data;
>> >> >> > -};
>> >> >> > -
>> >> >> > -struct hv_kvp_msg_delete {
>> >> >> > -       __u32 key_size;
>> >> >> > -       __u8 key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
>> >> >> > -};
>> >> >> > -
>> >> >> > -struct hv_kvp_register {
>> >> >> > -       __u8 version[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
>> >> >> > -};
>> >> >> > -
>> >> >> > -struct hv_kvp_msg {
>> >> >> > -       union {
>> >> >> > -               struct hv_kvp_hdr       kvp_hdr;
>> >> >> > -               int error;
>> >> >> > -       };
>> >> >> > -       union {
>> >> >> > -               struct hv_kvp_msg_get           kvp_get;
>> >> >> > -               struct hv_kvp_msg_set           kvp_set;
>> >> >> > -               struct hv_kvp_msg_delete        kvp_delete;
>> >> >> > -               struct hv_kvp_msg_enumerate     kvp_enum_data;
>> >> >> > -               struct hv_kvp_ipaddr_value      kvp_ip_val;
>> >> >> > -               struct hv_kvp_register          kvp_register;
>> >> >> > -       } body;
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -struct hv_kvp_ip_msg {
>> >> >> > -       __u8 operation;
>> >> >> > -       __u8 pool;
>> >> >> > -       struct hv_kvp_ipaddr_value      kvp_ip_val;
>> >> >> > -} __attribute__((packed));
>> >> >> > -
>> >> >> > -#ifdef __KERNEL__
>> >> >> > +#include <linux/types.h>
>> >> >> >  #include <linux/scatterlist.h>
>> >> >> >  #include <linux/list.h>
>> >> >> >  #include <linux/uuid.h>
>> >> >> > @@ -1465,5 +1149,4 @@ void hv_vss_onchannelcallback(void *);
>> >> >> >
>> >> >> >  extern __u32 vmbus_proto_version;
>> >> >> >
>> >> >> > -#endif /* __KERNEL__ */
>> >> >> >  #endif /* _HYPERV_H */
>> >> >> > diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
>> >> >> > index 33d2b8f..6389736 100644
>> >> >> > --- a/include/uapi/linux/Kbuild
>> >> >> > +++ b/include/uapi/linux/Kbuild
>> >> >> > @@ -139,6 +139,7 @@ header-y += hid.h
>> >> >> >  header-y += hiddev.h
>> >> >> >  header-y += hidraw.h
>> >> >> >  header-y += hpet.h
>> >> >> > +header-y += hyperv.h
>> >> >> >  header-y += hysdn_if.h
>> >> >> >  header-y += i2c-dev.h
>> >> >> >  header-y += i2c.h
>> >> >> > diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
>> >> >> > new file mode 100644
>> >> >> > index 0000000..1861f8e
>> >> >> > --- /dev/null
>> >> >> > +++ b/include/uapi/linux/hyperv.h
>> >> >> > @@ -0,0 +1,344 @@
>> >> >> > +/*
>> >> >> > + *
>> >> >> > + * Copyright (c) 2011, Microsoft Corporation.
>> >> >> > + *
>> >> >> > + * This program is free software; you can redistribute it and/or modify it
>> >> >> > + * under the terms and conditions of the GNU General Public License,
>> >> >> > + * version 2, as published by the Free Software Foundation.
>> >> >> > + *
>> >> >> > + * This program is distributed in the hope it will be useful, but WITHOUT
>> >> >> > + * ANY WARRANTY; without even the implied warranty of
>> >> MERCHANTABILITY
>> >> >> or
>> >> >> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>> >> License
>> >> >> for
>> >> >> > + * more details.
>> >> >> > + *
>> >> >> > + * You should have received a copy of the GNU General Public License
>> >> along
>> >> >> with
>> >> >> > + * this program; if not, write to the Free Software Foundation, Inc., 59
>> >> Temple
>> >> >> > + * Place - Suite 330, Boston, MA 02111-1307 USA.
>> >> >> > + *
>> >> >> > + * Authors:
>> >> >> > + *   Haiyang Zhang <haiyangz@microsoft.com>
>> >> >> > + *   Hank Janssen  <hjanssen@microsoft.com>
>> >> >> > + *   K. Y. Srinivasan <kys@microsoft.com>
>> >> >> > + *
>> >> >> > + */
>> >> >> > +
>> >> >> > +#ifndef _UAPI_HYPERV_H
>> >> >> > +#define _UAPI_HYPERV_H
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Framework version for util services.
>> >> >> > + */
>> >> >> > +#define UTIL_FW_MINOR  0
>> >> >> > +
>> >> >> > +#define UTIL_WS2K8_FW_MAJOR  1
>> >> >> > +#define UTIL_WS2K8_FW_VERSION     (UTIL_WS2K8_FW_MAJOR << 16
>> |
>> >> >> UTIL_FW_MINOR)
>> >> >> > +
>> >> >> > +#define UTIL_FW_MAJOR  3
>> >> >> > +#define UTIL_FW_VERSION     (UTIL_FW_MAJOR << 16 |
>> >> UTIL_FW_MINOR)
>> >> >> > +
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Implementation of host controlled snapshot of the guest.
>> >> >> > + */
>> >> >> > +
>> >> >> > +#define VSS_OP_REGISTER 128
>> >> >> > +
>> >> >> > +enum hv_vss_op {
>> >> >> > +       VSS_OP_CREATE = 0,
>> >> >> > +       VSS_OP_DELETE,
>> >> >> > +       VSS_OP_HOT_BACKUP,
>> >> >> > +       VSS_OP_GET_DM_INFO,
>> >> >> > +       VSS_OP_BU_COMPLETE,
>> >> >> > +       /*
>> >> >> > +        * Following operations are only supported with IC version >= 5.0
>> >> >> > +        */
>> >> >> > +       VSS_OP_FREEZE, /* Freeze the file systems in the VM */
>> >> >> > +       VSS_OP_THAW, /* Unfreeze the file systems */
>> >> >> > +       VSS_OP_AUTO_RECOVER,
>> >> >> > +       VSS_OP_COUNT /* Number of operations, must be last */
>> >> >> > +};
>> >> >> > +
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Header for all VSS messages.
>> >> >> > + */
>> >> >> > +struct hv_vss_hdr {
>> >> >> > +       __u8 operation;
>> >> >> > +       __u8 reserved[7];
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Flag values for the hv_vss_check_feature. Linux supports only
>> >> >> > + * one value.
>> >> >> > + */
>> >> >> > +#define VSS_HBU_NO_AUTO_RECOVERY       0x00000005
>> >> >> > +
>> >> >> > +struct hv_vss_check_feature {
>> >> >> > +       __u32 flags;
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +struct hv_vss_check_dm_info {
>> >> >> > +       __u32 flags;
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +struct hv_vss_msg {
>> >> >> > +       union {
>> >> >> > +               struct hv_vss_hdr vss_hdr;
>> >> >> > +               int error;
>> >> >> > +       };
>> >> >> > +       union {
>> >> >> > +               struct hv_vss_check_feature vss_cf;
>> >> >> > +               struct hv_vss_check_dm_info dm_info;
>> >> >> > +       };
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * An implementation of HyperV key value pair (KVP) functionality for
>> >> Linux.
>> >> >> > + *
>> >> >> > + *
>> >> >> > + * Copyright (C) 2010, Novell, Inc.
>> >> >> > + * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
>> >> >> > + *
>> >> >> > + */
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Maximum value size - used for both key names and value data, and
>> >> includes
>> >> >> > + * any applicable NULL terminators.
>> >> >> > + *
>> >> >> > + * Note:  This limit is somewhat arbitrary, but falls easily within what is
>> >> >> > + * supported for all native guests (back to Win 2000) and what is
>> reasonable
>> >> >> > + * for the IC KVP exchange functionality.  Note that Windows Me/98/95
>> are
>> >> >> > + * limited to 255 character key names.
>> >> >> > + *
>> >> >> > + * MSDN recommends not storing data values larger than 2048 bytes in
>> the
>> >> >> > + * registry.
>> >> >> > + *
>> >> >> > + * Note:  This value is used in defining the KVP exchange message - this
>> >> value
>> >> >> > + * cannot be modified without affecting the message size and
>> >> compatibility.
>> >> >> > + */
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * bytes, including any null terminators
>> >> >> > + */
>> >> >> > +#define HV_KVP_EXCHANGE_MAX_VALUE_SIZE          (2048)
>> >> >> > +
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Maximum key size - the registry limit for the length of an entry name
>> >> >> > + * is 256 characters, including the null terminator
>> >> >> > + */
>> >> >> > +
>> >> >> > +#define HV_KVP_EXCHANGE_MAX_KEY_SIZE            (512)
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * In Linux, we implement the KVP functionality in two components:
>> >> >> > + * 1) The kernel component which is packaged as part of the hv_utils
>> driver
>> >> >> > + * is responsible for communicating with the host and responsible for
>> >> >> > + * implementing the host/guest protocol. 2) A user level daemon that is
>> >> >> > + * responsible for data gathering.
>> >> >> > + *
>> >> >> > + * Host/Guest Protocol: The host iterates over an index and expects the
>> >> guest
>> >> >> > + * to assign a key name to the index and also return the value
>> >> corresponding
>> >> >> to
>> >> >> > + * the key. The host will have atmost one KVP transaction outstanding at
>> >> any
>> >> >> > + * given point in time. The host side iteration stops when the guest
>> returns
>> >> >> > + * an error. Microsoft has specified the following mapping of key names
>> to
>> >> >> > + * host specified index:
>> >> >> > + *
>> >> >> > + *     Index           Key Name
>> >> >> > + *     0               FullyQualifiedDomainName
>> >> >> > + *     1               IntegrationServicesVersion
>> >> >> > + *     2               NetworkAddressIPv4
>> >> >> > + *     3               NetworkAddressIPv6
>> >> >> > + *     4               OSBuildNumber
>> >> >> > + *     5               OSName
>> >> >> > + *     6               OSMajorVersion
>> >> >> > + *     7               OSMinorVersion
>> >> >> > + *     8               OSVersion
>> >> >> > + *     9               ProcessorArchitecture
>> >> >> > + *
>> >> >> > + * The Windows host expects the Key Name and Key Value to be
>> encoded
>> >> in
>> >> >> utf16.
>> >> >> > + *
>> >> >> > + * Guest Kernel/KVP Daemon Protocol: As noted earlier, we implement
>> all
>> >> of
>> >> >> the
>> >> >> > + * data gathering functionality in a user mode daemon. The user level
>> >> daemon
>> >> >> > + * is also responsible for binding the key name to the index as well. The
>> >> >> > + * kernel and user-level daemon communicate using a connector
>> channel.
>> >> >> > + *
>> >> >> > + * The user mode component first registers with the
>> >> >> > + * the kernel component. Subsequently, the kernel component
>> requests,
>> >> data
>> >> >> > + * for the specified keys. In response to this message the user mode
>> >> >> component
>> >> >> > + * fills in the value corresponding to the specified key. We overload the
>> >> >> > + * sequence field in the cn_msg header to define our KVP message
>> types.
>> >> >> > + *
>> >> >> > + *
>> >> >> > + * The kernel component simply acts as a conduit for communication
>> >> between
>> >> >> the
>> >> >> > + * Windows host and the user-level daemon. The kernel component
>> >> passes
>> >> >> up the
>> >> >> > + * index received from the Host to the user-level daemon. If the index is
>> >> >> > + * valid (supported), the corresponding key as well as its
>> >> >> > + * value (both are strings) is returned. If the index is invalid
>> >> >> > + * (not supported), a NULL key string is returned.
>> >> >> > + */
>> >> >> > +
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Registry value types.
>> >> >> > + */
>> >> >> > +
>> >> >> > +#define REG_SZ 1
>> >> >> > +#define REG_U32 4
>> >> >> > +#define REG_U64 8
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * As we look at expanding the KVP functionality to include
>> >> >> > + * IP injection functionality, we need to maintain binary
>> >> >> > + * compatibility with older daemons.
>> >> >> > + *
>> >> >> > + * The KVP opcodes are defined by the host and it was unfortunate
>> >> >> > + * that I chose to treat the registration operation as part of the
>> >> >> > + * KVP operations defined by the host.
>> >> >> > + * Here is the level of compatibility
>> >> >> > + * (between the user level daemon and the kernel KVP driver) that we
>> >> >> > + * will implement:
>> >> >> > + *
>> >> >> > + * An older daemon will always be supported on a newer driver.
>> >> >> > + * A given user level daemon will require a minimal version of the
>> >> >> > + * kernel driver.
>> >> >> > + * If we cannot handle the version differences, we will fail gracefully
>> >> >> > + * (this can happen when we have a user level daemon that is more
>> >> >> > + * advanced than the KVP driver.
>> >> >> > + *
>> >> >> > + * We will use values used in this handshake for determining if we have
>> >> >> > + * workable user level daemon and the kernel driver. We begin by
>> taking
>> >> the
>> >> >> > + * registration opcode out of the KVP opcode namespace. We will
>> >> however,
>> >> >> > + * maintain compatibility with the existing user-level daemon code.
>> >> >> > + */
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Daemon code not supporting IP injection (legacy daemon).
>> >> >> > + */
>> >> >> > +
>> >> >> > +#define KVP_OP_REGISTER        4
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Daemon code supporting IP injection.
>> >> >> > + * The KVP opcode field is used to communicate the
>> >> >> > + * registration information; so define a namespace that
>> >> >> > + * will be distinct from the host defined KVP opcode.
>> >> >> > + */
>> >> >> > +
>> >> >> > +#define KVP_OP_REGISTER1 100
>> >> >> > +
>> >> >> > +enum hv_kvp_exchg_op {
>> >> >> > +       KVP_OP_GET = 0,
>> >> >> > +       KVP_OP_SET,
>> >> >> > +       KVP_OP_DELETE,
>> >> >> > +       KVP_OP_ENUMERATE,
>> >> >> > +       KVP_OP_GET_IP_INFO,
>> >> >> > +       KVP_OP_SET_IP_INFO,
>> >> >> > +       KVP_OP_COUNT /* Number of operations, must be last. */
>> >> >> > +};
>> >> >> > +
>> >> >> > +enum hv_kvp_exchg_pool {
>> >> >> > +       KVP_POOL_EXTERNAL = 0,
>> >> >> > +       KVP_POOL_GUEST,
>> >> >> > +       KVP_POOL_AUTO,
>> >> >> > +       KVP_POOL_AUTO_EXTERNAL,
>> >> >> > +       KVP_POOL_AUTO_INTERNAL,
>> >> >> > +       KVP_POOL_COUNT /* Number of pools, must be last. */
>> >> >> > +};
>> >> >> > +
>> >> >> > +/*
>> >> >> > + * Some Hyper-V status codes.
>> >> >> > + */
>> >> >> > +
>> >> >> > +#define HV_S_OK                                0x00000000
>> >> >> > +#define HV_E_FAIL                      0x80004005
>> >> >> > +#define HV_S_CONT                      0x80070103
>> >> >> > +#define HV_ERROR_NOT_SUPPORTED         0x80070032
>> >> >> > +#define HV_ERROR_MACHINE_LOCKED                0x800704F7
>> >> >> > +#define HV_ERROR_DEVICE_NOT_CONNECTED  0x8007048F
>> >> >> > +#define HV_INVALIDARG                  0x80070057
>> >> >> > +#define HV_GUID_NOTFOUND               0x80041002
>> >> >> > +
>> >> >> > +#define ADDR_FAMILY_NONE       0x00
>> >> >> > +#define ADDR_FAMILY_IPV4       0x01
>> >> >> > +#define ADDR_FAMILY_IPV6       0x02
>> >> >> > +
>> >> >> > +#define MAX_ADAPTER_ID_SIZE    128
>> >> >> > +#define MAX_IP_ADDR_SIZE       1024
>> >> >> > +#define MAX_GATEWAY_SIZE       512
>> >> >> > +
>> >> >> > +
>> >> >> > +struct hv_kvp_ipaddr_value {
>> >> >> > +       __u16   adapter_id[MAX_ADAPTER_ID_SIZE];
>> >> >> > +       __u8    addr_family;
>> >> >> > +       __u8    dhcp_enabled;
>> >> >> > +       __u16   ip_addr[MAX_IP_ADDR_SIZE];
>> >> >> > +       __u16   sub_net[MAX_IP_ADDR_SIZE];
>> >> >> > +       __u16   gate_way[MAX_GATEWAY_SIZE];
>> >> >> > +       __u16   dns_addr[MAX_IP_ADDR_SIZE];
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +
>> >> >> > +struct hv_kvp_hdr {
>> >> >> > +       __u8 operation;
>> >> >> > +       __u8 pool;
>> >> >> > +       __u16 pad;
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +struct hv_kvp_exchg_msg_value {
>> >> >> > +       __u32 value_type;
>> >> >> > +       __u32 key_size;
>> >> >> > +       __u32 value_size;
>> >> >> > +       __u8 key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
>> >> >> > +       union {
>> >> >> > +               __u8 value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
>> >> >> > +               __u32 value_u32;
>> >> >> > +               __u64 value_u64;
>> >> >> > +       };
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +struct hv_kvp_msg_enumerate {
>> >> >> > +       __u32 index;
>> >> >> > +       struct hv_kvp_exchg_msg_value data;
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +struct hv_kvp_msg_get {
>> >> >> > +       struct hv_kvp_exchg_msg_value data;
>> >> >> > +};
>> >> >> > +
>> >> >> > +struct hv_kvp_msg_set {
>> >> >> > +       struct hv_kvp_exchg_msg_value data;
>> >> >> > +};
>> >> >> > +
>> >> >> > +struct hv_kvp_msg_delete {
>> >> >> > +       __u32 key_size;
>> >> >> > +       __u8 key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
>> >> >> > +};
>> >> >> > +
>> >> >> > +struct hv_kvp_register {
>> >> >> > +       __u8 version[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
>> >> >> > +};
>> >> >> > +
>> >> >> > +struct hv_kvp_msg {
>> >> >> > +       union {
>> >> >> > +               struct hv_kvp_hdr       kvp_hdr;
>> >> >> > +               int error;
>> >> >> > +       };
>> >> >> > +       union {
>> >> >> > +               struct hv_kvp_msg_get           kvp_get;
>> >> >> > +               struct hv_kvp_msg_set           kvp_set;
>> >> >> > +               struct hv_kvp_msg_delete        kvp_delete;
>> >> >> > +               struct hv_kvp_msg_enumerate     kvp_enum_data;
>> >> >> > +               struct hv_kvp_ipaddr_value      kvp_ip_val;
>> >> >> > +               struct hv_kvp_register          kvp_register;
>> >> >> > +       } body;
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +struct hv_kvp_ip_msg {
>> >> >> > +       __u8 operation;
>> >> >> > +       __u8 pool;
>> >> >> > +       struct hv_kvp_ipaddr_value      kvp_ip_val;
>> >> >> > +} __attribute__((packed));
>> >> >> > +
>> >> >> > +#endif /* _UAPI_HYPERV_H */
>> >> >> > --
>> >> >> > 1.8.5.3
>> >> >> >
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> > Please read the FAQ at  http://www.tux.org/lkml/
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
